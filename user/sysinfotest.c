#include "kernel/types.h"
#include "kernel/riscv.h"
#include "kernel/sysinfo.h"
#include "user/user.h"


void
sinfo(struct sysinfo *info) {
  if (sysinfo(info) < 0) {
    printf("FAIL: sysinfo failed");
    exit(1);
  }
}

// ─────────────────────────────────────────────
// In toàn bộ thông tin hệ thống hiện tại
// ─────────────────────────────────────────────
void
print_sysinfo(const char *label) {
  struct sysinfo info;
  sinfo(&info);
  printf("  [%s]\n", label);
  printf("    freemem    = %lu bytes  (%lu KB  /  %lu MB)\n",
         info.freemem,
         info.freemem / 1024,
         info.freemem / (1024 * 1024));
  printf("    nproc      = %lu  (processes not UNUSED)\n", info.nproc);
  printf("    nopenfiles = %lu  (open file entries in ftable)\n", info.nopenfiles);
}

//
// use sbrk() to count how many free physical memory pages there are.
//
int
countfree()
{
  uint64 sz0 = (uint64)sbrk(0);
  struct sysinfo info;
  int n = 0;

  while(1){
    if((uint64)sbrk(PGSIZE) == 0xffffffffffffffff){
      break;
    }
    n += PGSIZE;
  }
  sinfo(&info);
  if (info.freemem != 0) {
    printf("FAIL: there is no free mem, but sysinfo.freemem=%ld\n",
      info.freemem);
    exit(1);
  }
  sbrk(-((uint64)sbrk(0) - sz0));
  return n;
}

void
testmem() {
  struct sysinfo info;
  uint64 n = countfree();

  printf("\n--- testmem ---\n");
  printf("  countfree() total free         = %lu bytes (%lu MB)\n",
         n, n / (1024 * 1024));

  sinfo(&info);
  printf("  freemem before sbrk            = %lu bytes\n", info.freemem);

  if (info.freemem != n) {
    printf("  FAIL: free mem %ld instead of %ld\n", info.freemem, n);
    exit(1);
  }
  printf("  freemem == countfree()         -> OK\n");

  if((uint64)sbrk(PGSIZE) == 0xffffffffffffffff){
    printf("sbrk failed");
    exit(1);
  }

  sinfo(&info);
  printf("  freemem after sbrk(+%d)      = %lu bytes\n", PGSIZE, info.freemem);

  if (info.freemem != n-PGSIZE) {
    printf("  FAIL: free mem %ld instead of %ld\n", n-PGSIZE, info.freemem);
    exit(1);
  }
  printf("  freemem decreased by PGSIZE    -> OK\n");

  if((uint64)sbrk(-PGSIZE) == 0xffffffffffffffff){
    printf("sbrk failed");
    exit(1);
  }

  sinfo(&info);
  printf("  freemem after sbrk(-%d)      = %lu bytes\n", PGSIZE, info.freemem);

  if (info.freemem != n) {
    printf("  FAIL: free mem %ld instead of %ld\n", n, info.freemem);
    exit(1);
  }
  printf("  freemem restored to original   -> OK\n");
}

void
testcall() {
  printf("\n--- testcall ---\n");

  struct sysinfo info;

  if (sysinfo(&info) < 0) {
    printf("  FAIL: sysinfo failed\n");
    exit(1);
  }
  printf("  sysinfo with valid pointer     -> OK\n");

  if (sysinfo((struct sysinfo *) 0xeaeb0b5b00002f5e) != 0xffffffffffffffff) {
    printf("  FAIL: sysinfo succeeded with bad argument\n");
    exit(1);
  }
  printf("  sysinfo with bad pointer       -> returned -1  -> OK\n");
}

void testproc() {
  struct sysinfo info;
  uint64 nproc;
  int status;
  int pid;

  printf("\n--- testproc ---\n");

  sinfo(&info);
  nproc = info.nproc;
  printf("  nproc before fork              = %lu\n", nproc);

  pid = fork();
  if(pid < 0){
    printf("sysinfotest: fork failed\n");
    exit(1);
  }
  if(pid == 0){
    // child
    sinfo(&info);
    printf("  nproc inside child             = %lu  (expected %lu)\n",
           info.nproc, nproc + 1);
    if(info.nproc != nproc+1) {
      printf("  FAIL nproc is %ld instead of %ld\n", info.nproc, nproc+1);
      exit(1);
    }
    printf("  nproc increased by 1           -> OK\n");
    exit(0);
  }

  // parent
  wait(&status);
  sinfo(&info);
  printf("  nproc after child exits        = %lu  (expected %lu)\n",
         info.nproc, nproc);
  if(info.nproc != nproc) {
    printf("  FAIL nproc is %ld instead of %ld\n", info.nproc, nproc);
    exit(1);
  }
  printf("  nproc back to original         -> OK\n");
}

void testbad() {
  int pid = fork();
  int xstatus;

  if(pid < 0){
    printf("sysinfotest: fork failed\n");
    exit(1);
  }
  if(pid == 0){
    sinfo(0x0);
    exit(0);
  }
  wait(&xstatus);
  if(xstatus == -1)
    exit(0);
  else {
    printf("sysinfotest: testbad succeeded %d\n", xstatus);
    exit(xstatus);
  }
}

void
testopenfiles() {
  struct sysinfo info1, info2;
  int fd;

  printf("\n--- testopenfiles ---\n");

  sinfo(&info1);
  printf("  nopenfiles before open         = %lu\n", info1.nopenfiles);

  fd = open("README", 0);
  if(fd < 0){
    printf("  FAIL: open(README) failed\n");
    exit(1);
  }

  sinfo(&info2);
  printf("  nopenfiles after open          = %lu  (expected %lu)\n",
         info2.nopenfiles, info1.nopenfiles + 1);

  if(info2.nopenfiles != info1.nopenfiles + 1){
    printf("  FAIL nopenfiles is %ld instead of %ld\n",
           info2.nopenfiles, info1.nopenfiles + 1);
    close(fd);
    exit(1);
  }
  printf("  nopenfiles increased by 1      -> OK\n");

  close(fd);

  sinfo(&info2);
  printf("  nopenfiles after close         = %lu  (expected %lu)\n",
         info2.nopenfiles, info1.nopenfiles);

  if(info2.nopenfiles != info1.nopenfiles){
    printf("  FAIL nopenfiles after close is %ld instead of %ld\n",
           info2.nopenfiles, info1.nopenfiles);
    exit(1);
  }
  printf("  nopenfiles back to original    -> OK\n");
}

int
main(int argc, char *argv[])
{
  struct sysinfo info;

  if (sysinfo(&info) < 0) {
    printf("FAILED: sysinfo call failed\n");
    exit(1);
  }

  testcall();
  testmem();
  testproc();
  testopenfiles();

  printf("freemem    = %lu bytes\n", info.freemem);
  printf("nproc      = %lu\n",       info.nproc);
  printf("nopenfiles = %lu\n",       info.nopenfiles);
  printf("sysinfotest: OK\n");
  exit(0);
}