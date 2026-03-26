
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	43013103          	ld	sp,1072(sp) # 8000a430 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	619040ef          	jal	80004e2e <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	e3a9                	bnez	a5,8000006e <kfree+0x52>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00023797          	auipc	a5,0x23
    80000034:	78078793          	addi	a5,a5,1920 # 800237b0 <end>
    80000038:	02f56b63          	bltu	a0,a5,8000006e <kfree+0x52>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	02f57763          	bgeu	a0,a5,8000006e <kfree+0x52>
  memset(pa, 1, PGSIZE);
#endif
  
  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000044:	0000a917          	auipc	s2,0xa
    80000048:	43c90913          	addi	s2,s2,1084 # 8000a480 <kmem>
    8000004c:	854a                	mv	a0,s2
    8000004e:	043050ef          	jal	80005890 <acquire>
  r->next = kmem.freelist;
    80000052:	01893783          	ld	a5,24(s2)
    80000056:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000058:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000005c:	854a                	mv	a0,s2
    8000005e:	0cb050ef          	jal	80005928 <release>
}
    80000062:	60e2                	ld	ra,24(sp)
    80000064:	6442                	ld	s0,16(sp)
    80000066:	64a2                	ld	s1,8(sp)
    80000068:	6902                	ld	s2,0(sp)
    8000006a:	6105                	addi	sp,sp,32
    8000006c:	8082                	ret
    panic("kfree");
    8000006e:	00007517          	auipc	a0,0x7
    80000072:	f9250513          	addi	a0,a0,-110 # 80007000 <etext>
    80000076:	4ec050ef          	jal	80005562 <panic>

000000008000007a <freerange>:
{
    8000007a:	7179                	addi	sp,sp,-48
    8000007c:	f406                	sd	ra,40(sp)
    8000007e:	f022                	sd	s0,32(sp)
    80000080:	ec26                	sd	s1,24(sp)
    80000082:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000084:	6785                	lui	a5,0x1
    80000086:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    8000008a:	00e504b3          	add	s1,a0,a4
    8000008e:	777d                	lui	a4,0xfffff
    80000090:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    80000092:	94be                	add	s1,s1,a5
    80000094:	0295e263          	bltu	a1,s1,800000b8 <freerange+0x3e>
    80000098:	e84a                	sd	s2,16(sp)
    8000009a:	e44e                	sd	s3,8(sp)
    8000009c:	e052                	sd	s4,0(sp)
    8000009e:	892e                	mv	s2,a1
    kfree(p);
    800000a0:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    800000a2:	6985                	lui	s3,0x1
    kfree(p);
    800000a4:	01448533          	add	a0,s1,s4
    800000a8:	f75ff0ef          	jal	8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    800000ac:	94ce                	add	s1,s1,s3
    800000ae:	fe997be3          	bgeu	s2,s1,800000a4 <freerange+0x2a>
    800000b2:	6942                	ld	s2,16(sp)
    800000b4:	69a2                	ld	s3,8(sp)
    800000b6:	6a02                	ld	s4,0(sp)
}
    800000b8:	70a2                	ld	ra,40(sp)
    800000ba:	7402                	ld	s0,32(sp)
    800000bc:	64e2                	ld	s1,24(sp)
    800000be:	6145                	addi	sp,sp,48
    800000c0:	8082                	ret

00000000800000c2 <kinit>:
{
    800000c2:	1141                	addi	sp,sp,-16
    800000c4:	e406                	sd	ra,8(sp)
    800000c6:	e022                	sd	s0,0(sp)
    800000c8:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000ca:	00007597          	auipc	a1,0x7
    800000ce:	f3e58593          	addi	a1,a1,-194 # 80007008 <etext+0x8>
    800000d2:	0000a517          	auipc	a0,0xa
    800000d6:	3ae50513          	addi	a0,a0,942 # 8000a480 <kmem>
    800000da:	736050ef          	jal	80005810 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000de:	45c5                	li	a1,17
    800000e0:	05ee                	slli	a1,a1,0x1b
    800000e2:	00023517          	auipc	a0,0x23
    800000e6:	6ce50513          	addi	a0,a0,1742 # 800237b0 <end>
    800000ea:	f91ff0ef          	jal	8000007a <freerange>
}
    800000ee:	60a2                	ld	ra,8(sp)
    800000f0:	6402                	ld	s0,0(sp)
    800000f2:	0141                	addi	sp,sp,16
    800000f4:	8082                	ret

00000000800000f6 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    800000f6:	1101                	addi	sp,sp,-32
    800000f8:	ec06                	sd	ra,24(sp)
    800000fa:	e822                	sd	s0,16(sp)
    800000fc:	e426                	sd	s1,8(sp)
    800000fe:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000100:	0000a497          	auipc	s1,0xa
    80000104:	38048493          	addi	s1,s1,896 # 8000a480 <kmem>
    80000108:	8526                	mv	a0,s1
    8000010a:	786050ef          	jal	80005890 <acquire>
  r = kmem.freelist;
    8000010e:	6c84                	ld	s1,24(s1)
  if(r) {
    80000110:	c491                	beqz	s1,8000011c <kalloc+0x26>
    kmem.freelist = r->next;
    80000112:	609c                	ld	a5,0(s1)
    80000114:	0000a717          	auipc	a4,0xa
    80000118:	38f73223          	sd	a5,900(a4) # 8000a498 <kmem+0x18>
  }
  release(&kmem.lock);
    8000011c:	0000a517          	auipc	a0,0xa
    80000120:	36450513          	addi	a0,a0,868 # 8000a480 <kmem>
    80000124:	005050ef          	jal	80005928 <release>
#ifndef LAB_SYSCALL
  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
#endif
  return (void*)r;
}
    80000128:	8526                	mv	a0,s1
    8000012a:	60e2                	ld	ra,24(sp)
    8000012c:	6442                	ld	s0,16(sp)
    8000012e:	64a2                	ld	s1,8(sp)
    80000130:	6105                	addi	sp,sp,32
    80000132:	8082                	ret

0000000080000134 <freemem_count>:

uint64
freemem_count(void)
{
    80000134:	1101                	addi	sp,sp,-32
    80000136:	ec06                	sd	ra,24(sp)
    80000138:	e822                	sd	s0,16(sp)
    8000013a:	e426                	sd	s1,8(sp)
    8000013c:	1000                	addi	s0,sp,32
  struct run *r;
  uint64 count = 0;

  acquire(&kmem.lock);
    8000013e:	0000a497          	auipc	s1,0xa
    80000142:	34248493          	addi	s1,s1,834 # 8000a480 <kmem>
    80000146:	8526                	mv	a0,s1
    80000148:	748050ef          	jal	80005890 <acquire>

  r = kmem.freelist;
    8000014c:	6c9c                	ld	a5,24(s1)

  while(r){
    8000014e:	c395                	beqz	a5,80000172 <freemem_count+0x3e>
  uint64 count = 0;
    80000150:	4481                	li	s1,0
    count++;
    80000152:	0485                	addi	s1,s1,1
    r = r->next;
    80000154:	639c                	ld	a5,0(a5)
  while(r){
    80000156:	fff5                	bnez	a5,80000152 <freemem_count+0x1e>
  }

  release(&kmem.lock);
    80000158:	0000a517          	auipc	a0,0xa
    8000015c:	32850513          	addi	a0,a0,808 # 8000a480 <kmem>
    80000160:	7c8050ef          	jal	80005928 <release>

  return count * PGSIZE;
    80000164:	00c49513          	slli	a0,s1,0xc
    80000168:	60e2                	ld	ra,24(sp)
    8000016a:	6442                	ld	s0,16(sp)
    8000016c:	64a2                	ld	s1,8(sp)
    8000016e:	6105                	addi	sp,sp,32
    80000170:	8082                	ret
  uint64 count = 0;
    80000172:	4481                	li	s1,0
    80000174:	b7d5                	j	80000158 <freemem_count+0x24>

0000000080000176 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000176:	1141                	addi	sp,sp,-16
    80000178:	e422                	sd	s0,8(sp)
    8000017a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    8000017c:	ca19                	beqz	a2,80000192 <memset+0x1c>
    8000017e:	87aa                	mv	a5,a0
    80000180:	1602                	slli	a2,a2,0x20
    80000182:	9201                	srli	a2,a2,0x20
    80000184:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000188:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    8000018c:	0785                	addi	a5,a5,1
    8000018e:	fee79de3          	bne	a5,a4,80000188 <memset+0x12>
  }
  return dst;
}
    80000192:	6422                	ld	s0,8(sp)
    80000194:	0141                	addi	sp,sp,16
    80000196:	8082                	ret

0000000080000198 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000198:	1141                	addi	sp,sp,-16
    8000019a:	e422                	sd	s0,8(sp)
    8000019c:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    8000019e:	ca05                	beqz	a2,800001ce <memcmp+0x36>
    800001a0:	fff6069b          	addiw	a3,a2,-1
    800001a4:	1682                	slli	a3,a3,0x20
    800001a6:	9281                	srli	a3,a3,0x20
    800001a8:	0685                	addi	a3,a3,1
    800001aa:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001ac:	00054783          	lbu	a5,0(a0)
    800001b0:	0005c703          	lbu	a4,0(a1)
    800001b4:	00e79863          	bne	a5,a4,800001c4 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001b8:	0505                	addi	a0,a0,1
    800001ba:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001bc:	fed518e3          	bne	a0,a3,800001ac <memcmp+0x14>
  }

  return 0;
    800001c0:	4501                	li	a0,0
    800001c2:	a019                	j	800001c8 <memcmp+0x30>
      return *s1 - *s2;
    800001c4:	40e7853b          	subw	a0,a5,a4
}
    800001c8:	6422                	ld	s0,8(sp)
    800001ca:	0141                	addi	sp,sp,16
    800001cc:	8082                	ret
  return 0;
    800001ce:	4501                	li	a0,0
    800001d0:	bfe5                	j	800001c8 <memcmp+0x30>

00000000800001d2 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d2:	1141                	addi	sp,sp,-16
    800001d4:	e422                	sd	s0,8(sp)
    800001d6:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001d8:	c205                	beqz	a2,800001f8 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001da:	02a5e263          	bltu	a1,a0,800001fe <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001de:	1602                	slli	a2,a2,0x20
    800001e0:	9201                	srli	a2,a2,0x20
    800001e2:	00c587b3          	add	a5,a1,a2
{
    800001e6:	872a                	mv	a4,a0
      *d++ = *s++;
    800001e8:	0585                	addi	a1,a1,1
    800001ea:	0705                	addi	a4,a4,1
    800001ec:	fff5c683          	lbu	a3,-1(a1)
    800001f0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001f4:	feb79ae3          	bne	a5,a1,800001e8 <memmove+0x16>

  return dst;
}
    800001f8:	6422                	ld	s0,8(sp)
    800001fa:	0141                	addi	sp,sp,16
    800001fc:	8082                	ret
  if(s < d && s + n > d){
    800001fe:	02061693          	slli	a3,a2,0x20
    80000202:	9281                	srli	a3,a3,0x20
    80000204:	00d58733          	add	a4,a1,a3
    80000208:	fce57be3          	bgeu	a0,a4,800001de <memmove+0xc>
    d += n;
    8000020c:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    8000020e:	fff6079b          	addiw	a5,a2,-1
    80000212:	1782                	slli	a5,a5,0x20
    80000214:	9381                	srli	a5,a5,0x20
    80000216:	fff7c793          	not	a5,a5
    8000021a:	97ba                	add	a5,a5,a4
      *--d = *--s;
    8000021c:	177d                	addi	a4,a4,-1
    8000021e:	16fd                	addi	a3,a3,-1
    80000220:	00074603          	lbu	a2,0(a4)
    80000224:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000228:	fef71ae3          	bne	a4,a5,8000021c <memmove+0x4a>
    8000022c:	b7f1                	j	800001f8 <memmove+0x26>

000000008000022e <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    8000022e:	1141                	addi	sp,sp,-16
    80000230:	e406                	sd	ra,8(sp)
    80000232:	e022                	sd	s0,0(sp)
    80000234:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000236:	f9dff0ef          	jal	800001d2 <memmove>
}
    8000023a:	60a2                	ld	ra,8(sp)
    8000023c:	6402                	ld	s0,0(sp)
    8000023e:	0141                	addi	sp,sp,16
    80000240:	8082                	ret

0000000080000242 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000242:	1141                	addi	sp,sp,-16
    80000244:	e422                	sd	s0,8(sp)
    80000246:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000248:	ce11                	beqz	a2,80000264 <strncmp+0x22>
    8000024a:	00054783          	lbu	a5,0(a0)
    8000024e:	cf89                	beqz	a5,80000268 <strncmp+0x26>
    80000250:	0005c703          	lbu	a4,0(a1)
    80000254:	00f71a63          	bne	a4,a5,80000268 <strncmp+0x26>
    n--, p++, q++;
    80000258:	367d                	addiw	a2,a2,-1
    8000025a:	0505                	addi	a0,a0,1
    8000025c:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000025e:	f675                	bnez	a2,8000024a <strncmp+0x8>
  if(n == 0)
    return 0;
    80000260:	4501                	li	a0,0
    80000262:	a801                	j	80000272 <strncmp+0x30>
    80000264:	4501                	li	a0,0
    80000266:	a031                	j	80000272 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000268:	00054503          	lbu	a0,0(a0)
    8000026c:	0005c783          	lbu	a5,0(a1)
    80000270:	9d1d                	subw	a0,a0,a5
}
    80000272:	6422                	ld	s0,8(sp)
    80000274:	0141                	addi	sp,sp,16
    80000276:	8082                	ret

0000000080000278 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000278:	1141                	addi	sp,sp,-16
    8000027a:	e422                	sd	s0,8(sp)
    8000027c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    8000027e:	87aa                	mv	a5,a0
    80000280:	86b2                	mv	a3,a2
    80000282:	367d                	addiw	a2,a2,-1
    80000284:	02d05563          	blez	a3,800002ae <strncpy+0x36>
    80000288:	0785                	addi	a5,a5,1
    8000028a:	0005c703          	lbu	a4,0(a1)
    8000028e:	fee78fa3          	sb	a4,-1(a5)
    80000292:	0585                	addi	a1,a1,1
    80000294:	f775                	bnez	a4,80000280 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000296:	873e                	mv	a4,a5
    80000298:	9fb5                	addw	a5,a5,a3
    8000029a:	37fd                	addiw	a5,a5,-1
    8000029c:	00c05963          	blez	a2,800002ae <strncpy+0x36>
    *s++ = 0;
    800002a0:	0705                	addi	a4,a4,1
    800002a2:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    800002a6:	40e786bb          	subw	a3,a5,a4
    800002aa:	fed04be3          	bgtz	a3,800002a0 <strncpy+0x28>
  return os;
}
    800002ae:	6422                	ld	s0,8(sp)
    800002b0:	0141                	addi	sp,sp,16
    800002b2:	8082                	ret

00000000800002b4 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002b4:	1141                	addi	sp,sp,-16
    800002b6:	e422                	sd	s0,8(sp)
    800002b8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002ba:	02c05363          	blez	a2,800002e0 <safestrcpy+0x2c>
    800002be:	fff6069b          	addiw	a3,a2,-1
    800002c2:	1682                	slli	a3,a3,0x20
    800002c4:	9281                	srli	a3,a3,0x20
    800002c6:	96ae                	add	a3,a3,a1
    800002c8:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002ca:	00d58963          	beq	a1,a3,800002dc <safestrcpy+0x28>
    800002ce:	0585                	addi	a1,a1,1
    800002d0:	0785                	addi	a5,a5,1
    800002d2:	fff5c703          	lbu	a4,-1(a1)
    800002d6:	fee78fa3          	sb	a4,-1(a5)
    800002da:	fb65                	bnez	a4,800002ca <safestrcpy+0x16>
    ;
  *s = 0;
    800002dc:	00078023          	sb	zero,0(a5)
  return os;
}
    800002e0:	6422                	ld	s0,8(sp)
    800002e2:	0141                	addi	sp,sp,16
    800002e4:	8082                	ret

00000000800002e6 <strlen>:

int
strlen(const char *s)
{
    800002e6:	1141                	addi	sp,sp,-16
    800002e8:	e422                	sd	s0,8(sp)
    800002ea:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002ec:	00054783          	lbu	a5,0(a0)
    800002f0:	cf91                	beqz	a5,8000030c <strlen+0x26>
    800002f2:	0505                	addi	a0,a0,1
    800002f4:	87aa                	mv	a5,a0
    800002f6:	86be                	mv	a3,a5
    800002f8:	0785                	addi	a5,a5,1
    800002fa:	fff7c703          	lbu	a4,-1(a5)
    800002fe:	ff65                	bnez	a4,800002f6 <strlen+0x10>
    80000300:	40a6853b          	subw	a0,a3,a0
    80000304:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000306:	6422                	ld	s0,8(sp)
    80000308:	0141                	addi	sp,sp,16
    8000030a:	8082                	ret
  for(n = 0; s[n]; n++)
    8000030c:	4501                	li	a0,0
    8000030e:	bfe5                	j	80000306 <strlen+0x20>

0000000080000310 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000310:	1141                	addi	sp,sp,-16
    80000312:	e406                	sd	ra,8(sp)
    80000314:	e022                	sd	s0,0(sp)
    80000316:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000318:	255000ef          	jal	80000d6c <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    8000031c:	0000a717          	auipc	a4,0xa
    80000320:	13470713          	addi	a4,a4,308 # 8000a450 <started>
  if(cpuid() == 0){
    80000324:	c51d                	beqz	a0,80000352 <main+0x42>
    while(started == 0)
    80000326:	431c                	lw	a5,0(a4)
    80000328:	2781                	sext.w	a5,a5
    8000032a:	dff5                	beqz	a5,80000326 <main+0x16>
      ;
    __sync_synchronize();
    8000032c:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000330:	23d000ef          	jal	80000d6c <cpuid>
    80000334:	85aa                	mv	a1,a0
    80000336:	00007517          	auipc	a0,0x7
    8000033a:	cf250513          	addi	a0,a0,-782 # 80007028 <etext+0x28>
    8000033e:	753040ef          	jal	80005290 <printf>
    kvminithart();    // turn on paging
    80000342:	080000ef          	jal	800003c2 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000346:	58e010ef          	jal	800018d4 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000034a:	4fe040ef          	jal	80004848 <plicinithart>
  }

  scheduler();        
    8000034e:	67f000ef          	jal	800011cc <scheduler>
    consoleinit();
    80000352:	669040ef          	jal	800051ba <consoleinit>
    printfinit();
    80000356:	246050ef          	jal	8000559c <printfinit>
    printf("\n");
    8000035a:	00007517          	auipc	a0,0x7
    8000035e:	cde50513          	addi	a0,a0,-802 # 80007038 <etext+0x38>
    80000362:	72f040ef          	jal	80005290 <printf>
    printf("xv6 kernel is booting\n");
    80000366:	00007517          	auipc	a0,0x7
    8000036a:	caa50513          	addi	a0,a0,-854 # 80007010 <etext+0x10>
    8000036e:	723040ef          	jal	80005290 <printf>
    printf("\n");
    80000372:	00007517          	auipc	a0,0x7
    80000376:	cc650513          	addi	a0,a0,-826 # 80007038 <etext+0x38>
    8000037a:	717040ef          	jal	80005290 <printf>
    kinit();         // physical page allocator
    8000037e:	d45ff0ef          	jal	800000c2 <kinit>
    kvminit();       // create kernel page table
    80000382:	2ca000ef          	jal	8000064c <kvminit>
    kvminithart();   // turn on paging
    80000386:	03c000ef          	jal	800003c2 <kvminithart>
    procinit();      // process table
    8000038a:	12d000ef          	jal	80000cb6 <procinit>
    trapinit();      // trap vectors
    8000038e:	522010ef          	jal	800018b0 <trapinit>
    trapinithart();  // install kernel trap vector
    80000392:	542010ef          	jal	800018d4 <trapinithart>
    plicinit();      // set up interrupt controller
    80000396:	498040ef          	jal	8000482e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000039a:	4ae040ef          	jal	80004848 <plicinithart>
    binit();         // buffer cache
    8000039e:	407010ef          	jal	80001fa4 <binit>
    iinit();         // inode table
    800003a2:	1f8020ef          	jal	8000259a <iinit>
    fileinit();      // file table
    800003a6:	7a5020ef          	jal	8000334a <fileinit>
    virtio_disk_init(); // emulated hard disk
    800003aa:	58e040ef          	jal	80004938 <virtio_disk_init>
    userinit();      // first user process
    800003ae:	453000ef          	jal	80001000 <userinit>
    __sync_synchronize();
    800003b2:	0330000f          	fence	rw,rw
    started = 1;
    800003b6:	4785                	li	a5,1
    800003b8:	0000a717          	auipc	a4,0xa
    800003bc:	08f72c23          	sw	a5,152(a4) # 8000a450 <started>
    800003c0:	b779                	j	8000034e <main+0x3e>

00000000800003c2 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    800003c2:	1141                	addi	sp,sp,-16
    800003c4:	e422                	sd	s0,8(sp)
    800003c6:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800003c8:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    800003cc:	0000a797          	auipc	a5,0xa
    800003d0:	08c7b783          	ld	a5,140(a5) # 8000a458 <kernel_pagetable>
    800003d4:	83b1                	srli	a5,a5,0xc
    800003d6:	577d                	li	a4,-1
    800003d8:	177e                	slli	a4,a4,0x3f
    800003da:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    800003dc:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800003e0:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800003e4:	6422                	ld	s0,8(sp)
    800003e6:	0141                	addi	sp,sp,16
    800003e8:	8082                	ret

00000000800003ea <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800003ea:	7139                	addi	sp,sp,-64
    800003ec:	fc06                	sd	ra,56(sp)
    800003ee:	f822                	sd	s0,48(sp)
    800003f0:	f426                	sd	s1,40(sp)
    800003f2:	f04a                	sd	s2,32(sp)
    800003f4:	ec4e                	sd	s3,24(sp)
    800003f6:	e852                	sd	s4,16(sp)
    800003f8:	e456                	sd	s5,8(sp)
    800003fa:	e05a                	sd	s6,0(sp)
    800003fc:	0080                	addi	s0,sp,64
    800003fe:	84aa                	mv	s1,a0
    80000400:	89ae                	mv	s3,a1
    80000402:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000404:	57fd                	li	a5,-1
    80000406:	83e9                	srli	a5,a5,0x1a
    80000408:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000040a:	4b31                	li	s6,12
  if(va >= MAXVA)
    8000040c:	02b7fc63          	bgeu	a5,a1,80000444 <walk+0x5a>
    panic("walk");
    80000410:	00007517          	auipc	a0,0x7
    80000414:	c3050513          	addi	a0,a0,-976 # 80007040 <etext+0x40>
    80000418:	14a050ef          	jal	80005562 <panic>
      if(PTE_LEAF(*pte)) {
        return pte;
      }
#endif
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    8000041c:	060a8263          	beqz	s5,80000480 <walk+0x96>
    80000420:	cd7ff0ef          	jal	800000f6 <kalloc>
    80000424:	84aa                	mv	s1,a0
    80000426:	c139                	beqz	a0,8000046c <walk+0x82>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000428:	6605                	lui	a2,0x1
    8000042a:	4581                	li	a1,0
    8000042c:	d4bff0ef          	jal	80000176 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000430:	00c4d793          	srli	a5,s1,0xc
    80000434:	07aa                	slli	a5,a5,0xa
    80000436:	0017e793          	ori	a5,a5,1
    8000043a:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    8000043e:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdb847>
    80000440:	036a0063          	beq	s4,s6,80000460 <walk+0x76>
    pte_t *pte = &pagetable[PX(level, va)];
    80000444:	0149d933          	srl	s2,s3,s4
    80000448:	1ff97913          	andi	s2,s2,511
    8000044c:	090e                	slli	s2,s2,0x3
    8000044e:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000450:	00093483          	ld	s1,0(s2)
    80000454:	0014f793          	andi	a5,s1,1
    80000458:	d3f1                	beqz	a5,8000041c <walk+0x32>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000045a:	80a9                	srli	s1,s1,0xa
    8000045c:	04b2                	slli	s1,s1,0xc
    8000045e:	b7c5                	j	8000043e <walk+0x54>
    }
  }
  return &pagetable[PX(0, va)];
    80000460:	00c9d513          	srli	a0,s3,0xc
    80000464:	1ff57513          	andi	a0,a0,511
    80000468:	050e                	slli	a0,a0,0x3
    8000046a:	9526                	add	a0,a0,s1
}
    8000046c:	70e2                	ld	ra,56(sp)
    8000046e:	7442                	ld	s0,48(sp)
    80000470:	74a2                	ld	s1,40(sp)
    80000472:	7902                	ld	s2,32(sp)
    80000474:	69e2                	ld	s3,24(sp)
    80000476:	6a42                	ld	s4,16(sp)
    80000478:	6aa2                	ld	s5,8(sp)
    8000047a:	6b02                	ld	s6,0(sp)
    8000047c:	6121                	addi	sp,sp,64
    8000047e:	8082                	ret
        return 0;
    80000480:	4501                	li	a0,0
    80000482:	b7ed                	j	8000046c <walk+0x82>

0000000080000484 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000484:	57fd                	li	a5,-1
    80000486:	83e9                	srli	a5,a5,0x1a
    80000488:	00b7f463          	bgeu	a5,a1,80000490 <walkaddr+0xc>
    return 0;
    8000048c:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000048e:	8082                	ret
{
    80000490:	1141                	addi	sp,sp,-16
    80000492:	e406                	sd	ra,8(sp)
    80000494:	e022                	sd	s0,0(sp)
    80000496:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000498:	4601                	li	a2,0
    8000049a:	f51ff0ef          	jal	800003ea <walk>
  if(pte == 0)
    8000049e:	c105                	beqz	a0,800004be <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    800004a0:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    800004a2:	0117f693          	andi	a3,a5,17
    800004a6:	4745                	li	a4,17
    return 0;
    800004a8:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800004aa:	00e68663          	beq	a3,a4,800004b6 <walkaddr+0x32>
}
    800004ae:	60a2                	ld	ra,8(sp)
    800004b0:	6402                	ld	s0,0(sp)
    800004b2:	0141                	addi	sp,sp,16
    800004b4:	8082                	ret
  pa = PTE2PA(*pte);
    800004b6:	83a9                	srli	a5,a5,0xa
    800004b8:	00c79513          	slli	a0,a5,0xc
  return pa;
    800004bc:	bfcd                	j	800004ae <walkaddr+0x2a>
    return 0;
    800004be:	4501                	li	a0,0
    800004c0:	b7fd                	j	800004ae <walkaddr+0x2a>

00000000800004c2 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800004c2:	715d                	addi	sp,sp,-80
    800004c4:	e486                	sd	ra,72(sp)
    800004c6:	e0a2                	sd	s0,64(sp)
    800004c8:	fc26                	sd	s1,56(sp)
    800004ca:	f84a                	sd	s2,48(sp)
    800004cc:	f44e                	sd	s3,40(sp)
    800004ce:	f052                	sd	s4,32(sp)
    800004d0:	ec56                	sd	s5,24(sp)
    800004d2:	e85a                	sd	s6,16(sp)
    800004d4:	e45e                	sd	s7,8(sp)
    800004d6:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800004d8:	03459793          	slli	a5,a1,0x34
    800004dc:	e7a9                	bnez	a5,80000526 <mappages+0x64>
    800004de:	8aaa                	mv	s5,a0
    800004e0:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    800004e2:	03461793          	slli	a5,a2,0x34
    800004e6:	e7b1                	bnez	a5,80000532 <mappages+0x70>
    panic("mappages: size not aligned");

  if(size == 0)
    800004e8:	ca39                	beqz	a2,8000053e <mappages+0x7c>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    800004ea:	77fd                	lui	a5,0xfffff
    800004ec:	963e                	add	a2,a2,a5
    800004ee:	00b609b3          	add	s3,a2,a1
  a = va;
    800004f2:	892e                	mv	s2,a1
    800004f4:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800004f8:	6b85                	lui	s7,0x1
    800004fa:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    800004fe:	4605                	li	a2,1
    80000500:	85ca                	mv	a1,s2
    80000502:	8556                	mv	a0,s5
    80000504:	ee7ff0ef          	jal	800003ea <walk>
    80000508:	c539                	beqz	a0,80000556 <mappages+0x94>
    if(*pte & PTE_V)
    8000050a:	611c                	ld	a5,0(a0)
    8000050c:	8b85                	andi	a5,a5,1
    8000050e:	ef95                	bnez	a5,8000054a <mappages+0x88>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000510:	80b1                	srli	s1,s1,0xc
    80000512:	04aa                	slli	s1,s1,0xa
    80000514:	0164e4b3          	or	s1,s1,s6
    80000518:	0014e493          	ori	s1,s1,1
    8000051c:	e104                	sd	s1,0(a0)
    if(a == last)
    8000051e:	05390863          	beq	s2,s3,8000056e <mappages+0xac>
    a += PGSIZE;
    80000522:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80000524:	bfd9                	j	800004fa <mappages+0x38>
    panic("mappages: va not aligned");
    80000526:	00007517          	auipc	a0,0x7
    8000052a:	b2250513          	addi	a0,a0,-1246 # 80007048 <etext+0x48>
    8000052e:	034050ef          	jal	80005562 <panic>
    panic("mappages: size not aligned");
    80000532:	00007517          	auipc	a0,0x7
    80000536:	b3650513          	addi	a0,a0,-1226 # 80007068 <etext+0x68>
    8000053a:	028050ef          	jal	80005562 <panic>
    panic("mappages: size");
    8000053e:	00007517          	auipc	a0,0x7
    80000542:	b4a50513          	addi	a0,a0,-1206 # 80007088 <etext+0x88>
    80000546:	01c050ef          	jal	80005562 <panic>
      panic("mappages: remap");
    8000054a:	00007517          	auipc	a0,0x7
    8000054e:	b4e50513          	addi	a0,a0,-1202 # 80007098 <etext+0x98>
    80000552:	010050ef          	jal	80005562 <panic>
      return -1;
    80000556:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80000558:	60a6                	ld	ra,72(sp)
    8000055a:	6406                	ld	s0,64(sp)
    8000055c:	74e2                	ld	s1,56(sp)
    8000055e:	7942                	ld	s2,48(sp)
    80000560:	79a2                	ld	s3,40(sp)
    80000562:	7a02                	ld	s4,32(sp)
    80000564:	6ae2                	ld	s5,24(sp)
    80000566:	6b42                	ld	s6,16(sp)
    80000568:	6ba2                	ld	s7,8(sp)
    8000056a:	6161                	addi	sp,sp,80
    8000056c:	8082                	ret
  return 0;
    8000056e:	4501                	li	a0,0
    80000570:	b7e5                	j	80000558 <mappages+0x96>

0000000080000572 <kvmmap>:
{
    80000572:	1141                	addi	sp,sp,-16
    80000574:	e406                	sd	ra,8(sp)
    80000576:	e022                	sd	s0,0(sp)
    80000578:	0800                	addi	s0,sp,16
    8000057a:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000057c:	86b2                	mv	a3,a2
    8000057e:	863e                	mv	a2,a5
    80000580:	f43ff0ef          	jal	800004c2 <mappages>
    80000584:	e509                	bnez	a0,8000058e <kvmmap+0x1c>
}
    80000586:	60a2                	ld	ra,8(sp)
    80000588:	6402                	ld	s0,0(sp)
    8000058a:	0141                	addi	sp,sp,16
    8000058c:	8082                	ret
    panic("kvmmap");
    8000058e:	00007517          	auipc	a0,0x7
    80000592:	b1a50513          	addi	a0,a0,-1254 # 800070a8 <etext+0xa8>
    80000596:	7cd040ef          	jal	80005562 <panic>

000000008000059a <kvmmake>:
{
    8000059a:	1101                	addi	sp,sp,-32
    8000059c:	ec06                	sd	ra,24(sp)
    8000059e:	e822                	sd	s0,16(sp)
    800005a0:	e426                	sd	s1,8(sp)
    800005a2:	e04a                	sd	s2,0(sp)
    800005a4:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800005a6:	b51ff0ef          	jal	800000f6 <kalloc>
    800005aa:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800005ac:	6605                	lui	a2,0x1
    800005ae:	4581                	li	a1,0
    800005b0:	bc7ff0ef          	jal	80000176 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800005b4:	4719                	li	a4,6
    800005b6:	6685                	lui	a3,0x1
    800005b8:	10000637          	lui	a2,0x10000
    800005bc:	100005b7          	lui	a1,0x10000
    800005c0:	8526                	mv	a0,s1
    800005c2:	fb1ff0ef          	jal	80000572 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800005c6:	4719                	li	a4,6
    800005c8:	6685                	lui	a3,0x1
    800005ca:	10001637          	lui	a2,0x10001
    800005ce:	100015b7          	lui	a1,0x10001
    800005d2:	8526                	mv	a0,s1
    800005d4:	f9fff0ef          	jal	80000572 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    800005d8:	4719                	li	a4,6
    800005da:	040006b7          	lui	a3,0x4000
    800005de:	0c000637          	lui	a2,0xc000
    800005e2:	0c0005b7          	lui	a1,0xc000
    800005e6:	8526                	mv	a0,s1
    800005e8:	f8bff0ef          	jal	80000572 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800005ec:	00007917          	auipc	s2,0x7
    800005f0:	a1490913          	addi	s2,s2,-1516 # 80007000 <etext>
    800005f4:	4729                	li	a4,10
    800005f6:	80007697          	auipc	a3,0x80007
    800005fa:	a0a68693          	addi	a3,a3,-1526 # 7000 <_entry-0x7fff9000>
    800005fe:	4605                	li	a2,1
    80000600:	067e                	slli	a2,a2,0x1f
    80000602:	85b2                	mv	a1,a2
    80000604:	8526                	mv	a0,s1
    80000606:	f6dff0ef          	jal	80000572 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000060a:	46c5                	li	a3,17
    8000060c:	06ee                	slli	a3,a3,0x1b
    8000060e:	4719                	li	a4,6
    80000610:	412686b3          	sub	a3,a3,s2
    80000614:	864a                	mv	a2,s2
    80000616:	85ca                	mv	a1,s2
    80000618:	8526                	mv	a0,s1
    8000061a:	f59ff0ef          	jal	80000572 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000061e:	4729                	li	a4,10
    80000620:	6685                	lui	a3,0x1
    80000622:	00006617          	auipc	a2,0x6
    80000626:	9de60613          	addi	a2,a2,-1570 # 80006000 <_trampoline>
    8000062a:	040005b7          	lui	a1,0x4000
    8000062e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000630:	05b2                	slli	a1,a1,0xc
    80000632:	8526                	mv	a0,s1
    80000634:	f3fff0ef          	jal	80000572 <kvmmap>
  proc_mapstacks(kpgtbl);
    80000638:	8526                	mv	a0,s1
    8000063a:	5e4000ef          	jal	80000c1e <proc_mapstacks>
}
    8000063e:	8526                	mv	a0,s1
    80000640:	60e2                	ld	ra,24(sp)
    80000642:	6442                	ld	s0,16(sp)
    80000644:	64a2                	ld	s1,8(sp)
    80000646:	6902                	ld	s2,0(sp)
    80000648:	6105                	addi	sp,sp,32
    8000064a:	8082                	ret

000000008000064c <kvminit>:
{
    8000064c:	1141                	addi	sp,sp,-16
    8000064e:	e406                	sd	ra,8(sp)
    80000650:	e022                	sd	s0,0(sp)
    80000652:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000654:	f47ff0ef          	jal	8000059a <kvmmake>
    80000658:	0000a797          	auipc	a5,0xa
    8000065c:	e0a7b023          	sd	a0,-512(a5) # 8000a458 <kernel_pagetable>
}
    80000660:	60a2                	ld	ra,8(sp)
    80000662:	6402                	ld	s0,0(sp)
    80000664:	0141                	addi	sp,sp,16
    80000666:	8082                	ret

0000000080000668 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000668:	715d                	addi	sp,sp,-80
    8000066a:	e486                	sd	ra,72(sp)
    8000066c:	e0a2                	sd	s0,64(sp)
    8000066e:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;
  int sz;

  if((va % PGSIZE) != 0)
    80000670:	03459793          	slli	a5,a1,0x34
    80000674:	e39d                	bnez	a5,8000069a <uvmunmap+0x32>
    80000676:	f84a                	sd	s2,48(sp)
    80000678:	f44e                	sd	s3,40(sp)
    8000067a:	f052                	sd	s4,32(sp)
    8000067c:	ec56                	sd	s5,24(sp)
    8000067e:	e85a                	sd	s6,16(sp)
    80000680:	e45e                	sd	s7,8(sp)
    80000682:	8a2a                	mv	s4,a0
    80000684:	892e                	mv	s2,a1
    80000686:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += sz){
    80000688:	0632                	slli	a2,a2,0xc
    8000068a:	00b609b3          	add	s3,a2,a1
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0) {
      printf("va=%ld pte=%ld\n", a, *pte);
      panic("uvmunmap: not mapped");
    }
    if(PTE_FLAGS(*pte) == PTE_V)
    8000068e:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += sz){
    80000690:	6b05                	lui	s6,0x1
    80000692:	0935f763          	bgeu	a1,s3,80000720 <uvmunmap+0xb8>
    80000696:	fc26                	sd	s1,56(sp)
    80000698:	a8a1                	j	800006f0 <uvmunmap+0x88>
    8000069a:	fc26                	sd	s1,56(sp)
    8000069c:	f84a                	sd	s2,48(sp)
    8000069e:	f44e                	sd	s3,40(sp)
    800006a0:	f052                	sd	s4,32(sp)
    800006a2:	ec56                	sd	s5,24(sp)
    800006a4:	e85a                	sd	s6,16(sp)
    800006a6:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    800006a8:	00007517          	auipc	a0,0x7
    800006ac:	a0850513          	addi	a0,a0,-1528 # 800070b0 <etext+0xb0>
    800006b0:	6b3040ef          	jal	80005562 <panic>
      panic("uvmunmap: walk");
    800006b4:	00007517          	auipc	a0,0x7
    800006b8:	a1450513          	addi	a0,a0,-1516 # 800070c8 <etext+0xc8>
    800006bc:	6a7040ef          	jal	80005562 <panic>
      printf("va=%ld pte=%ld\n", a, *pte);
    800006c0:	85ca                	mv	a1,s2
    800006c2:	00007517          	auipc	a0,0x7
    800006c6:	a1650513          	addi	a0,a0,-1514 # 800070d8 <etext+0xd8>
    800006ca:	3c7040ef          	jal	80005290 <printf>
      panic("uvmunmap: not mapped");
    800006ce:	00007517          	auipc	a0,0x7
    800006d2:	a1a50513          	addi	a0,a0,-1510 # 800070e8 <etext+0xe8>
    800006d6:	68d040ef          	jal	80005562 <panic>
      panic("uvmunmap: not a leaf");
    800006da:	00007517          	auipc	a0,0x7
    800006de:	a2650513          	addi	a0,a0,-1498 # 80007100 <etext+0x100>
    800006e2:	681040ef          	jal	80005562 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    800006e6:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += sz){
    800006ea:	995a                	add	s2,s2,s6
    800006ec:	03397963          	bgeu	s2,s3,8000071e <uvmunmap+0xb6>
    if((pte = walk(pagetable, a, 0)) == 0)
    800006f0:	4601                	li	a2,0
    800006f2:	85ca                	mv	a1,s2
    800006f4:	8552                	mv	a0,s4
    800006f6:	cf5ff0ef          	jal	800003ea <walk>
    800006fa:	84aa                	mv	s1,a0
    800006fc:	dd45                	beqz	a0,800006b4 <uvmunmap+0x4c>
    if((*pte & PTE_V) == 0) {
    800006fe:	6110                	ld	a2,0(a0)
    80000700:	00167793          	andi	a5,a2,1
    80000704:	dfd5                	beqz	a5,800006c0 <uvmunmap+0x58>
    if(PTE_FLAGS(*pte) == PTE_V)
    80000706:	3ff67793          	andi	a5,a2,1023
    8000070a:	fd7788e3          	beq	a5,s7,800006da <uvmunmap+0x72>
    if(do_free){
    8000070e:	fc0a8ce3          	beqz	s5,800006e6 <uvmunmap+0x7e>
      uint64 pa = PTE2PA(*pte);
    80000712:	8229                	srli	a2,a2,0xa
      kfree((void*)pa);
    80000714:	00c61513          	slli	a0,a2,0xc
    80000718:	905ff0ef          	jal	8000001c <kfree>
    8000071c:	b7e9                	j	800006e6 <uvmunmap+0x7e>
    8000071e:	74e2                	ld	s1,56(sp)
    80000720:	7942                	ld	s2,48(sp)
    80000722:	79a2                	ld	s3,40(sp)
    80000724:	7a02                	ld	s4,32(sp)
    80000726:	6ae2                	ld	s5,24(sp)
    80000728:	6b42                	ld	s6,16(sp)
    8000072a:	6ba2                	ld	s7,8(sp)
  }
}
    8000072c:	60a6                	ld	ra,72(sp)
    8000072e:	6406                	ld	s0,64(sp)
    80000730:	6161                	addi	sp,sp,80
    80000732:	8082                	ret

0000000080000734 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80000734:	1101                	addi	sp,sp,-32
    80000736:	ec06                	sd	ra,24(sp)
    80000738:	e822                	sd	s0,16(sp)
    8000073a:	e426                	sd	s1,8(sp)
    8000073c:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    8000073e:	9b9ff0ef          	jal	800000f6 <kalloc>
    80000742:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000744:	c509                	beqz	a0,8000074e <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000746:	6605                	lui	a2,0x1
    80000748:	4581                	li	a1,0
    8000074a:	a2dff0ef          	jal	80000176 <memset>
  return pagetable;
}
    8000074e:	8526                	mv	a0,s1
    80000750:	60e2                	ld	ra,24(sp)
    80000752:	6442                	ld	s0,16(sp)
    80000754:	64a2                	ld	s1,8(sp)
    80000756:	6105                	addi	sp,sp,32
    80000758:	8082                	ret

000000008000075a <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    8000075a:	7179                	addi	sp,sp,-48
    8000075c:	f406                	sd	ra,40(sp)
    8000075e:	f022                	sd	s0,32(sp)
    80000760:	ec26                	sd	s1,24(sp)
    80000762:	e84a                	sd	s2,16(sp)
    80000764:	e44e                	sd	s3,8(sp)
    80000766:	e052                	sd	s4,0(sp)
    80000768:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000076a:	6785                	lui	a5,0x1
    8000076c:	04f67063          	bgeu	a2,a5,800007ac <uvmfirst+0x52>
    80000770:	8a2a                	mv	s4,a0
    80000772:	89ae                	mv	s3,a1
    80000774:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000776:	981ff0ef          	jal	800000f6 <kalloc>
    8000077a:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000077c:	6605                	lui	a2,0x1
    8000077e:	4581                	li	a1,0
    80000780:	9f7ff0ef          	jal	80000176 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000784:	4779                	li	a4,30
    80000786:	86ca                	mv	a3,s2
    80000788:	6605                	lui	a2,0x1
    8000078a:	4581                	li	a1,0
    8000078c:	8552                	mv	a0,s4
    8000078e:	d35ff0ef          	jal	800004c2 <mappages>
  memmove(mem, src, sz);
    80000792:	8626                	mv	a2,s1
    80000794:	85ce                	mv	a1,s3
    80000796:	854a                	mv	a0,s2
    80000798:	a3bff0ef          	jal	800001d2 <memmove>
}
    8000079c:	70a2                	ld	ra,40(sp)
    8000079e:	7402                	ld	s0,32(sp)
    800007a0:	64e2                	ld	s1,24(sp)
    800007a2:	6942                	ld	s2,16(sp)
    800007a4:	69a2                	ld	s3,8(sp)
    800007a6:	6a02                	ld	s4,0(sp)
    800007a8:	6145                	addi	sp,sp,48
    800007aa:	8082                	ret
    panic("uvmfirst: more than a page");
    800007ac:	00007517          	auipc	a0,0x7
    800007b0:	96c50513          	addi	a0,a0,-1684 # 80007118 <etext+0x118>
    800007b4:	5af040ef          	jal	80005562 <panic>

00000000800007b8 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800007b8:	1101                	addi	sp,sp,-32
    800007ba:	ec06                	sd	ra,24(sp)
    800007bc:	e822                	sd	s0,16(sp)
    800007be:	e426                	sd	s1,8(sp)
    800007c0:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800007c2:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800007c4:	00b67d63          	bgeu	a2,a1,800007de <uvmdealloc+0x26>
    800007c8:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800007ca:	6785                	lui	a5,0x1
    800007cc:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800007ce:	00f60733          	add	a4,a2,a5
    800007d2:	76fd                	lui	a3,0xfffff
    800007d4:	8f75                	and	a4,a4,a3
    800007d6:	97ae                	add	a5,a5,a1
    800007d8:	8ff5                	and	a5,a5,a3
    800007da:	00f76863          	bltu	a4,a5,800007ea <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800007de:	8526                	mv	a0,s1
    800007e0:	60e2                	ld	ra,24(sp)
    800007e2:	6442                	ld	s0,16(sp)
    800007e4:	64a2                	ld	s1,8(sp)
    800007e6:	6105                	addi	sp,sp,32
    800007e8:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800007ea:	8f99                	sub	a5,a5,a4
    800007ec:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800007ee:	4685                	li	a3,1
    800007f0:	0007861b          	sext.w	a2,a5
    800007f4:	85ba                	mv	a1,a4
    800007f6:	e73ff0ef          	jal	80000668 <uvmunmap>
    800007fa:	b7d5                	j	800007de <uvmdealloc+0x26>

00000000800007fc <uvmalloc>:
  if(newsz < oldsz)
    800007fc:	08b66b63          	bltu	a2,a1,80000892 <uvmalloc+0x96>
{
    80000800:	7139                	addi	sp,sp,-64
    80000802:	fc06                	sd	ra,56(sp)
    80000804:	f822                	sd	s0,48(sp)
    80000806:	ec4e                	sd	s3,24(sp)
    80000808:	e852                	sd	s4,16(sp)
    8000080a:	e456                	sd	s5,8(sp)
    8000080c:	0080                	addi	s0,sp,64
    8000080e:	8aaa                	mv	s5,a0
    80000810:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80000812:	6785                	lui	a5,0x1
    80000814:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000816:	95be                	add	a1,a1,a5
    80000818:	77fd                	lui	a5,0xfffff
    8000081a:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += sz){
    8000081e:	06c9fc63          	bgeu	s3,a2,80000896 <uvmalloc+0x9a>
    80000822:	f426                	sd	s1,40(sp)
    80000824:	f04a                	sd	s2,32(sp)
    80000826:	e05a                	sd	s6,0(sp)
    80000828:	894e                	mv	s2,s3
    if(mappages(pagetable, a, sz, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000082a:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    8000082e:	8c9ff0ef          	jal	800000f6 <kalloc>
    80000832:	84aa                	mv	s1,a0
    if(mem == 0){
    80000834:	c115                	beqz	a0,80000858 <uvmalloc+0x5c>
    if(mappages(pagetable, a, sz, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000836:	875a                	mv	a4,s6
    80000838:	86aa                	mv	a3,a0
    8000083a:	6605                	lui	a2,0x1
    8000083c:	85ca                	mv	a1,s2
    8000083e:	8556                	mv	a0,s5
    80000840:	c83ff0ef          	jal	800004c2 <mappages>
    80000844:	e915                	bnez	a0,80000878 <uvmalloc+0x7c>
  for(a = oldsz; a < newsz; a += sz){
    80000846:	6785                	lui	a5,0x1
    80000848:	993e                	add	s2,s2,a5
    8000084a:	ff4962e3          	bltu	s2,s4,8000082e <uvmalloc+0x32>
  return newsz;
    8000084e:	8552                	mv	a0,s4
    80000850:	74a2                	ld	s1,40(sp)
    80000852:	7902                	ld	s2,32(sp)
    80000854:	6b02                	ld	s6,0(sp)
    80000856:	a811                	j	8000086a <uvmalloc+0x6e>
      uvmdealloc(pagetable, a, oldsz);
    80000858:	864e                	mv	a2,s3
    8000085a:	85ca                	mv	a1,s2
    8000085c:	8556                	mv	a0,s5
    8000085e:	f5bff0ef          	jal	800007b8 <uvmdealloc>
      return 0;
    80000862:	4501                	li	a0,0
    80000864:	74a2                	ld	s1,40(sp)
    80000866:	7902                	ld	s2,32(sp)
    80000868:	6b02                	ld	s6,0(sp)
}
    8000086a:	70e2                	ld	ra,56(sp)
    8000086c:	7442                	ld	s0,48(sp)
    8000086e:	69e2                	ld	s3,24(sp)
    80000870:	6a42                	ld	s4,16(sp)
    80000872:	6aa2                	ld	s5,8(sp)
    80000874:	6121                	addi	sp,sp,64
    80000876:	8082                	ret
      kfree(mem);
    80000878:	8526                	mv	a0,s1
    8000087a:	fa2ff0ef          	jal	8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000087e:	864e                	mv	a2,s3
    80000880:	85ca                	mv	a1,s2
    80000882:	8556                	mv	a0,s5
    80000884:	f35ff0ef          	jal	800007b8 <uvmdealloc>
      return 0;
    80000888:	4501                	li	a0,0
    8000088a:	74a2                	ld	s1,40(sp)
    8000088c:	7902                	ld	s2,32(sp)
    8000088e:	6b02                	ld	s6,0(sp)
    80000890:	bfe9                	j	8000086a <uvmalloc+0x6e>
    return oldsz;
    80000892:	852e                	mv	a0,a1
}
    80000894:	8082                	ret
  return newsz;
    80000896:	8532                	mv	a0,a2
    80000898:	bfc9                	j	8000086a <uvmalloc+0x6e>

000000008000089a <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000089a:	7179                	addi	sp,sp,-48
    8000089c:	f406                	sd	ra,40(sp)
    8000089e:	f022                	sd	s0,32(sp)
    800008a0:	ec26                	sd	s1,24(sp)
    800008a2:	e84a                	sd	s2,16(sp)
    800008a4:	e44e                	sd	s3,8(sp)
    800008a6:	e052                	sd	s4,0(sp)
    800008a8:	1800                	addi	s0,sp,48
    800008aa:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800008ac:	84aa                	mv	s1,a0
    800008ae:	6905                	lui	s2,0x1
    800008b0:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800008b2:	4985                	li	s3,1
    800008b4:	a819                	j	800008ca <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800008b6:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800008b8:	00c79513          	slli	a0,a5,0xc
    800008bc:	fdfff0ef          	jal	8000089a <freewalk>
      pagetable[i] = 0;
    800008c0:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800008c4:	04a1                	addi	s1,s1,8
    800008c6:	01248f63          	beq	s1,s2,800008e4 <freewalk+0x4a>
    pte_t pte = pagetable[i];
    800008ca:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800008cc:	00f7f713          	andi	a4,a5,15
    800008d0:	ff3703e3          	beq	a4,s3,800008b6 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800008d4:	8b85                	andi	a5,a5,1
    800008d6:	d7fd                	beqz	a5,800008c4 <freewalk+0x2a>
      panic("freewalk: leaf");
    800008d8:	00007517          	auipc	a0,0x7
    800008dc:	86050513          	addi	a0,a0,-1952 # 80007138 <etext+0x138>
    800008e0:	483040ef          	jal	80005562 <panic>
    }
  }
  kfree((void*)pagetable);
    800008e4:	8552                	mv	a0,s4
    800008e6:	f36ff0ef          	jal	8000001c <kfree>
}
    800008ea:	70a2                	ld	ra,40(sp)
    800008ec:	7402                	ld	s0,32(sp)
    800008ee:	64e2                	ld	s1,24(sp)
    800008f0:	6942                	ld	s2,16(sp)
    800008f2:	69a2                	ld	s3,8(sp)
    800008f4:	6a02                	ld	s4,0(sp)
    800008f6:	6145                	addi	sp,sp,48
    800008f8:	8082                	ret

00000000800008fa <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800008fa:	1101                	addi	sp,sp,-32
    800008fc:	ec06                	sd	ra,24(sp)
    800008fe:	e822                	sd	s0,16(sp)
    80000900:	e426                	sd	s1,8(sp)
    80000902:	1000                	addi	s0,sp,32
    80000904:	84aa                	mv	s1,a0
  if(sz > 0)
    80000906:	e989                	bnez	a1,80000918 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000908:	8526                	mv	a0,s1
    8000090a:	f91ff0ef          	jal	8000089a <freewalk>
}
    8000090e:	60e2                	ld	ra,24(sp)
    80000910:	6442                	ld	s0,16(sp)
    80000912:	64a2                	ld	s1,8(sp)
    80000914:	6105                	addi	sp,sp,32
    80000916:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000918:	6785                	lui	a5,0x1
    8000091a:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000091c:	95be                	add	a1,a1,a5
    8000091e:	4685                	li	a3,1
    80000920:	00c5d613          	srli	a2,a1,0xc
    80000924:	4581                	li	a1,0
    80000926:	d43ff0ef          	jal	80000668 <uvmunmap>
    8000092a:	bff9                	j	80000908 <uvmfree+0xe>

000000008000092c <uvmcopy>:
  uint64 pa, i;
  uint flags;
  char *mem;
  int szinc;

  for(i = 0; i < sz; i += szinc){
    8000092c:	c65d                	beqz	a2,800009da <uvmcopy+0xae>
{
    8000092e:	715d                	addi	sp,sp,-80
    80000930:	e486                	sd	ra,72(sp)
    80000932:	e0a2                	sd	s0,64(sp)
    80000934:	fc26                	sd	s1,56(sp)
    80000936:	f84a                	sd	s2,48(sp)
    80000938:	f44e                	sd	s3,40(sp)
    8000093a:	f052                	sd	s4,32(sp)
    8000093c:	ec56                	sd	s5,24(sp)
    8000093e:	e85a                	sd	s6,16(sp)
    80000940:	e45e                	sd	s7,8(sp)
    80000942:	0880                	addi	s0,sp,80
    80000944:	8b2a                	mv	s6,a0
    80000946:	8aae                	mv	s5,a1
    80000948:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += szinc){
    8000094a:	4981                	li	s3,0
    szinc = PGSIZE;
    szinc = PGSIZE;
    if((pte = walk(old, i, 0)) == 0)
    8000094c:	4601                	li	a2,0
    8000094e:	85ce                	mv	a1,s3
    80000950:	855a                	mv	a0,s6
    80000952:	a99ff0ef          	jal	800003ea <walk>
    80000956:	c121                	beqz	a0,80000996 <uvmcopy+0x6a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000958:	6118                	ld	a4,0(a0)
    8000095a:	00177793          	andi	a5,a4,1
    8000095e:	c3b1                	beqz	a5,800009a2 <uvmcopy+0x76>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000960:	00a75593          	srli	a1,a4,0xa
    80000964:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000968:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    8000096c:	f8aff0ef          	jal	800000f6 <kalloc>
    80000970:	892a                	mv	s2,a0
    80000972:	c129                	beqz	a0,800009b4 <uvmcopy+0x88>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000974:	6605                	lui	a2,0x1
    80000976:	85de                	mv	a1,s7
    80000978:	85bff0ef          	jal	800001d2 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    8000097c:	8726                	mv	a4,s1
    8000097e:	86ca                	mv	a3,s2
    80000980:	6605                	lui	a2,0x1
    80000982:	85ce                	mv	a1,s3
    80000984:	8556                	mv	a0,s5
    80000986:	b3dff0ef          	jal	800004c2 <mappages>
    8000098a:	e115                	bnez	a0,800009ae <uvmcopy+0x82>
  for(i = 0; i < sz; i += szinc){
    8000098c:	6785                	lui	a5,0x1
    8000098e:	99be                	add	s3,s3,a5
    80000990:	fb49eee3          	bltu	s3,s4,8000094c <uvmcopy+0x20>
    80000994:	a805                	j	800009c4 <uvmcopy+0x98>
      panic("uvmcopy: pte should exist");
    80000996:	00006517          	auipc	a0,0x6
    8000099a:	7b250513          	addi	a0,a0,1970 # 80007148 <etext+0x148>
    8000099e:	3c5040ef          	jal	80005562 <panic>
      panic("uvmcopy: page not present");
    800009a2:	00006517          	auipc	a0,0x6
    800009a6:	7c650513          	addi	a0,a0,1990 # 80007168 <etext+0x168>
    800009aa:	3b9040ef          	jal	80005562 <panic>
      kfree(mem);
    800009ae:	854a                	mv	a0,s2
    800009b0:	e6cff0ef          	jal	8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800009b4:	4685                	li	a3,1
    800009b6:	00c9d613          	srli	a2,s3,0xc
    800009ba:	4581                	li	a1,0
    800009bc:	8556                	mv	a0,s5
    800009be:	cabff0ef          	jal	80000668 <uvmunmap>
  return -1;
    800009c2:	557d                	li	a0,-1
}
    800009c4:	60a6                	ld	ra,72(sp)
    800009c6:	6406                	ld	s0,64(sp)
    800009c8:	74e2                	ld	s1,56(sp)
    800009ca:	7942                	ld	s2,48(sp)
    800009cc:	79a2                	ld	s3,40(sp)
    800009ce:	7a02                	ld	s4,32(sp)
    800009d0:	6ae2                	ld	s5,24(sp)
    800009d2:	6b42                	ld	s6,16(sp)
    800009d4:	6ba2                	ld	s7,8(sp)
    800009d6:	6161                	addi	sp,sp,80
    800009d8:	8082                	ret
  return 0;
    800009da:	4501                	li	a0,0
}
    800009dc:	8082                	ret

00000000800009de <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800009de:	1141                	addi	sp,sp,-16
    800009e0:	e406                	sd	ra,8(sp)
    800009e2:	e022                	sd	s0,0(sp)
    800009e4:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800009e6:	4601                	li	a2,0
    800009e8:	a03ff0ef          	jal	800003ea <walk>
  if(pte == 0)
    800009ec:	c901                	beqz	a0,800009fc <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800009ee:	611c                	ld	a5,0(a0)
    800009f0:	9bbd                	andi	a5,a5,-17
    800009f2:	e11c                	sd	a5,0(a0)
}
    800009f4:	60a2                	ld	ra,8(sp)
    800009f6:	6402                	ld	s0,0(sp)
    800009f8:	0141                	addi	sp,sp,16
    800009fa:	8082                	ret
    panic("uvmclear");
    800009fc:	00006517          	auipc	a0,0x6
    80000a00:	78c50513          	addi	a0,a0,1932 # 80007188 <etext+0x188>
    80000a04:	35f040ef          	jal	80005562 <panic>

0000000080000a08 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80000a08:	cac1                	beqz	a3,80000a98 <copyout+0x90>
{
    80000a0a:	711d                	addi	sp,sp,-96
    80000a0c:	ec86                	sd	ra,88(sp)
    80000a0e:	e8a2                	sd	s0,80(sp)
    80000a10:	e4a6                	sd	s1,72(sp)
    80000a12:	fc4e                	sd	s3,56(sp)
    80000a14:	f852                	sd	s4,48(sp)
    80000a16:	f456                	sd	s5,40(sp)
    80000a18:	f05a                	sd	s6,32(sp)
    80000a1a:	1080                	addi	s0,sp,96
    80000a1c:	8b2a                	mv	s6,a0
    80000a1e:	8a2e                	mv	s4,a1
    80000a20:	8ab2                	mv	s5,a2
    80000a22:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000a24:	74fd                	lui	s1,0xfffff
    80000a26:	8ced                	and	s1,s1,a1
    if (va0 >= MAXVA)
    80000a28:	57fd                	li	a5,-1
    80000a2a:	83e9                	srli	a5,a5,0x1a
    80000a2c:	0697e863          	bltu	a5,s1,80000a9c <copyout+0x94>
    80000a30:	e0ca                	sd	s2,64(sp)
    80000a32:	ec5e                	sd	s7,24(sp)
    80000a34:	e862                	sd	s8,16(sp)
    80000a36:	e466                	sd	s9,8(sp)
    80000a38:	6c05                	lui	s8,0x1
    80000a3a:	8bbe                	mv	s7,a5
    80000a3c:	a015                	j	80000a60 <copyout+0x58>
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000a3e:	409a04b3          	sub	s1,s4,s1
    80000a42:	0009061b          	sext.w	a2,s2
    80000a46:	85d6                	mv	a1,s5
    80000a48:	9526                	add	a0,a0,s1
    80000a4a:	f88ff0ef          	jal	800001d2 <memmove>

    len -= n;
    80000a4e:	412989b3          	sub	s3,s3,s2
    src += n;
    80000a52:	9aca                	add	s5,s5,s2
  while(len > 0){
    80000a54:	02098c63          	beqz	s3,80000a8c <copyout+0x84>
    if (va0 >= MAXVA)
    80000a58:	059be463          	bltu	s7,s9,80000aa0 <copyout+0x98>
    80000a5c:	84e6                	mv	s1,s9
    80000a5e:	8a66                	mv	s4,s9
    if((pte = walk(pagetable, va0, 0)) == 0) {
    80000a60:	4601                	li	a2,0
    80000a62:	85a6                	mv	a1,s1
    80000a64:	855a                	mv	a0,s6
    80000a66:	985ff0ef          	jal	800003ea <walk>
    80000a6a:	c129                	beqz	a0,80000aac <copyout+0xa4>
    if((*pte & PTE_W) == 0)
    80000a6c:	611c                	ld	a5,0(a0)
    80000a6e:	8b91                	andi	a5,a5,4
    80000a70:	cfa1                	beqz	a5,80000ac8 <copyout+0xc0>
    pa0 = walkaddr(pagetable, va0);
    80000a72:	85a6                	mv	a1,s1
    80000a74:	855a                	mv	a0,s6
    80000a76:	a0fff0ef          	jal	80000484 <walkaddr>
    if(pa0 == 0)
    80000a7a:	cd29                	beqz	a0,80000ad4 <copyout+0xcc>
    n = PGSIZE - (dstva - va0);
    80000a7c:	01848cb3          	add	s9,s1,s8
    80000a80:	414c8933          	sub	s2,s9,s4
    if(n > len)
    80000a84:	fb29fde3          	bgeu	s3,s2,80000a3e <copyout+0x36>
    80000a88:	894e                	mv	s2,s3
    80000a8a:	bf55                	j	80000a3e <copyout+0x36>
    dstva = va0 + PGSIZE;
  }
  return 0;
    80000a8c:	4501                	li	a0,0
    80000a8e:	6906                	ld	s2,64(sp)
    80000a90:	6be2                	ld	s7,24(sp)
    80000a92:	6c42                	ld	s8,16(sp)
    80000a94:	6ca2                	ld	s9,8(sp)
    80000a96:	a005                	j	80000ab6 <copyout+0xae>
    80000a98:	4501                	li	a0,0
}
    80000a9a:	8082                	ret
      return -1;
    80000a9c:	557d                	li	a0,-1
    80000a9e:	a821                	j	80000ab6 <copyout+0xae>
    80000aa0:	557d                	li	a0,-1
    80000aa2:	6906                	ld	s2,64(sp)
    80000aa4:	6be2                	ld	s7,24(sp)
    80000aa6:	6c42                	ld	s8,16(sp)
    80000aa8:	6ca2                	ld	s9,8(sp)
    80000aaa:	a031                	j	80000ab6 <copyout+0xae>
      return -1;
    80000aac:	557d                	li	a0,-1
    80000aae:	6906                	ld	s2,64(sp)
    80000ab0:	6be2                	ld	s7,24(sp)
    80000ab2:	6c42                	ld	s8,16(sp)
    80000ab4:	6ca2                	ld	s9,8(sp)
}
    80000ab6:	60e6                	ld	ra,88(sp)
    80000ab8:	6446                	ld	s0,80(sp)
    80000aba:	64a6                	ld	s1,72(sp)
    80000abc:	79e2                	ld	s3,56(sp)
    80000abe:	7a42                	ld	s4,48(sp)
    80000ac0:	7aa2                	ld	s5,40(sp)
    80000ac2:	7b02                	ld	s6,32(sp)
    80000ac4:	6125                	addi	sp,sp,96
    80000ac6:	8082                	ret
      return -1;
    80000ac8:	557d                	li	a0,-1
    80000aca:	6906                	ld	s2,64(sp)
    80000acc:	6be2                	ld	s7,24(sp)
    80000ace:	6c42                	ld	s8,16(sp)
    80000ad0:	6ca2                	ld	s9,8(sp)
    80000ad2:	b7d5                	j	80000ab6 <copyout+0xae>
      return -1;
    80000ad4:	557d                	li	a0,-1
    80000ad6:	6906                	ld	s2,64(sp)
    80000ad8:	6be2                	ld	s7,24(sp)
    80000ada:	6c42                	ld	s8,16(sp)
    80000adc:	6ca2                	ld	s9,8(sp)
    80000ade:	bfe1                	j	80000ab6 <copyout+0xae>

0000000080000ae0 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;
  
  while(len > 0){
    80000ae0:	c6a5                	beqz	a3,80000b48 <copyin+0x68>
{
    80000ae2:	715d                	addi	sp,sp,-80
    80000ae4:	e486                	sd	ra,72(sp)
    80000ae6:	e0a2                	sd	s0,64(sp)
    80000ae8:	fc26                	sd	s1,56(sp)
    80000aea:	f84a                	sd	s2,48(sp)
    80000aec:	f44e                	sd	s3,40(sp)
    80000aee:	f052                	sd	s4,32(sp)
    80000af0:	ec56                	sd	s5,24(sp)
    80000af2:	e85a                	sd	s6,16(sp)
    80000af4:	e45e                	sd	s7,8(sp)
    80000af6:	e062                	sd	s8,0(sp)
    80000af8:	0880                	addi	s0,sp,80
    80000afa:	8b2a                	mv	s6,a0
    80000afc:	8a2e                	mv	s4,a1
    80000afe:	8c32                	mv	s8,a2
    80000b00:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000b02:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000b04:	6a85                	lui	s5,0x1
    80000b06:	a00d                	j	80000b28 <copyin+0x48>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000b08:	018505b3          	add	a1,a0,s8
    80000b0c:	0004861b          	sext.w	a2,s1
    80000b10:	412585b3          	sub	a1,a1,s2
    80000b14:	8552                	mv	a0,s4
    80000b16:	ebcff0ef          	jal	800001d2 <memmove>

    len -= n;
    80000b1a:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000b1e:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000b20:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b24:	02098063          	beqz	s3,80000b44 <copyin+0x64>
    va0 = PGROUNDDOWN(srcva);
    80000b28:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b2c:	85ca                	mv	a1,s2
    80000b2e:	855a                	mv	a0,s6
    80000b30:	955ff0ef          	jal	80000484 <walkaddr>
    if(pa0 == 0)
    80000b34:	cd01                	beqz	a0,80000b4c <copyin+0x6c>
    n = PGSIZE - (srcva - va0);
    80000b36:	418904b3          	sub	s1,s2,s8
    80000b3a:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b3c:	fc99f6e3          	bgeu	s3,s1,80000b08 <copyin+0x28>
    80000b40:	84ce                	mv	s1,s3
    80000b42:	b7d9                	j	80000b08 <copyin+0x28>
  }
  return 0;
    80000b44:	4501                	li	a0,0
    80000b46:	a021                	j	80000b4e <copyin+0x6e>
    80000b48:	4501                	li	a0,0
}
    80000b4a:	8082                	ret
      return -1;
    80000b4c:	557d                	li	a0,-1
}
    80000b4e:	60a6                	ld	ra,72(sp)
    80000b50:	6406                	ld	s0,64(sp)
    80000b52:	74e2                	ld	s1,56(sp)
    80000b54:	7942                	ld	s2,48(sp)
    80000b56:	79a2                	ld	s3,40(sp)
    80000b58:	7a02                	ld	s4,32(sp)
    80000b5a:	6ae2                	ld	s5,24(sp)
    80000b5c:	6b42                	ld	s6,16(sp)
    80000b5e:	6ba2                	ld	s7,8(sp)
    80000b60:	6c02                	ld	s8,0(sp)
    80000b62:	6161                	addi	sp,sp,80
    80000b64:	8082                	ret

0000000080000b66 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000b66:	c6dd                	beqz	a3,80000c14 <copyinstr+0xae>
{
    80000b68:	715d                	addi	sp,sp,-80
    80000b6a:	e486                	sd	ra,72(sp)
    80000b6c:	e0a2                	sd	s0,64(sp)
    80000b6e:	fc26                	sd	s1,56(sp)
    80000b70:	f84a                	sd	s2,48(sp)
    80000b72:	f44e                	sd	s3,40(sp)
    80000b74:	f052                	sd	s4,32(sp)
    80000b76:	ec56                	sd	s5,24(sp)
    80000b78:	e85a                	sd	s6,16(sp)
    80000b7a:	e45e                	sd	s7,8(sp)
    80000b7c:	0880                	addi	s0,sp,80
    80000b7e:	8a2a                	mv	s4,a0
    80000b80:	8b2e                	mv	s6,a1
    80000b82:	8bb2                	mv	s7,a2
    80000b84:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80000b86:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000b88:	6985                	lui	s3,0x1
    80000b8a:	a825                	j	80000bc2 <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000b8c:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000b90:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000b92:	37fd                	addiw	a5,a5,-1
    80000b94:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000b98:	60a6                	ld	ra,72(sp)
    80000b9a:	6406                	ld	s0,64(sp)
    80000b9c:	74e2                	ld	s1,56(sp)
    80000b9e:	7942                	ld	s2,48(sp)
    80000ba0:	79a2                	ld	s3,40(sp)
    80000ba2:	7a02                	ld	s4,32(sp)
    80000ba4:	6ae2                	ld	s5,24(sp)
    80000ba6:	6b42                	ld	s6,16(sp)
    80000ba8:	6ba2                	ld	s7,8(sp)
    80000baa:	6161                	addi	sp,sp,80
    80000bac:	8082                	ret
    80000bae:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    80000bb2:	9742                	add	a4,a4,a6
      --max;
    80000bb4:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80000bb8:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80000bbc:	04e58463          	beq	a1,a4,80000c04 <copyinstr+0x9e>
{
    80000bc0:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80000bc2:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000bc6:	85a6                	mv	a1,s1
    80000bc8:	8552                	mv	a0,s4
    80000bca:	8bbff0ef          	jal	80000484 <walkaddr>
    if(pa0 == 0)
    80000bce:	cd0d                	beqz	a0,80000c08 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000bd0:	417486b3          	sub	a3,s1,s7
    80000bd4:	96ce                	add	a3,a3,s3
    if(n > max)
    80000bd6:	00d97363          	bgeu	s2,a3,80000bdc <copyinstr+0x76>
    80000bda:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80000bdc:	955e                	add	a0,a0,s7
    80000bde:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80000be0:	c695                	beqz	a3,80000c0c <copyinstr+0xa6>
    80000be2:	87da                	mv	a5,s6
    80000be4:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000be6:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000bea:	96da                	add	a3,a3,s6
    80000bec:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000bee:	00f60733          	add	a4,a2,a5
    80000bf2:	00074703          	lbu	a4,0(a4)
    80000bf6:	db59                	beqz	a4,80000b8c <copyinstr+0x26>
        *dst = *p;
    80000bf8:	00e78023          	sb	a4,0(a5)
      dst++;
    80000bfc:	0785                	addi	a5,a5,1
    while(n > 0){
    80000bfe:	fed797e3          	bne	a5,a3,80000bec <copyinstr+0x86>
    80000c02:	b775                	j	80000bae <copyinstr+0x48>
    80000c04:	4781                	li	a5,0
    80000c06:	b771                	j	80000b92 <copyinstr+0x2c>
      return -1;
    80000c08:	557d                	li	a0,-1
    80000c0a:	b779                	j	80000b98 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80000c0c:	6b85                	lui	s7,0x1
    80000c0e:	9ba6                	add	s7,s7,s1
    80000c10:	87da                	mv	a5,s6
    80000c12:	b77d                	j	80000bc0 <copyinstr+0x5a>
  int got_null = 0;
    80000c14:	4781                	li	a5,0
  if(got_null){
    80000c16:	37fd                	addiw	a5,a5,-1
    80000c18:	0007851b          	sext.w	a0,a5
}
    80000c1c:	8082                	ret

0000000080000c1e <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000c1e:	7139                	addi	sp,sp,-64
    80000c20:	fc06                	sd	ra,56(sp)
    80000c22:	f822                	sd	s0,48(sp)
    80000c24:	f426                	sd	s1,40(sp)
    80000c26:	f04a                	sd	s2,32(sp)
    80000c28:	ec4e                	sd	s3,24(sp)
    80000c2a:	e852                	sd	s4,16(sp)
    80000c2c:	e456                	sd	s5,8(sp)
    80000c2e:	e05a                	sd	s6,0(sp)
    80000c30:	0080                	addi	s0,sp,64
    80000c32:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c34:	0000a497          	auipc	s1,0xa
    80000c38:	c9c48493          	addi	s1,s1,-868 # 8000a8d0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000c3c:	8b26                	mv	s6,s1
    80000c3e:	04fa5937          	lui	s2,0x4fa5
    80000c42:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80000c46:	0932                	slli	s2,s2,0xc
    80000c48:	fa590913          	addi	s2,s2,-91
    80000c4c:	0932                	slli	s2,s2,0xc
    80000c4e:	fa590913          	addi	s2,s2,-91
    80000c52:	0932                	slli	s2,s2,0xc
    80000c54:	fa590913          	addi	s2,s2,-91
    80000c58:	040009b7          	lui	s3,0x4000
    80000c5c:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000c5e:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c60:	0000fa97          	auipc	s5,0xf
    80000c64:	670a8a93          	addi	s5,s5,1648 # 800102d0 <tickslock>
    char *pa = kalloc();
    80000c68:	c8eff0ef          	jal	800000f6 <kalloc>
    80000c6c:	862a                	mv	a2,a0
    if(pa == 0)
    80000c6e:	cd15                	beqz	a0,80000caa <proc_mapstacks+0x8c>
    uint64 va = KSTACK((int) (p - proc));
    80000c70:	416485b3          	sub	a1,s1,s6
    80000c74:	858d                	srai	a1,a1,0x3
    80000c76:	032585b3          	mul	a1,a1,s2
    80000c7a:	2585                	addiw	a1,a1,1
    80000c7c:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000c80:	4719                	li	a4,6
    80000c82:	6685                	lui	a3,0x1
    80000c84:	40b985b3          	sub	a1,s3,a1
    80000c88:	8552                	mv	a0,s4
    80000c8a:	8e9ff0ef          	jal	80000572 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c8e:	16848493          	addi	s1,s1,360
    80000c92:	fd549be3          	bne	s1,s5,80000c68 <proc_mapstacks+0x4a>
  }
}
    80000c96:	70e2                	ld	ra,56(sp)
    80000c98:	7442                	ld	s0,48(sp)
    80000c9a:	74a2                	ld	s1,40(sp)
    80000c9c:	7902                	ld	s2,32(sp)
    80000c9e:	69e2                	ld	s3,24(sp)
    80000ca0:	6a42                	ld	s4,16(sp)
    80000ca2:	6aa2                	ld	s5,8(sp)
    80000ca4:	6b02                	ld	s6,0(sp)
    80000ca6:	6121                	addi	sp,sp,64
    80000ca8:	8082                	ret
      panic("kalloc");
    80000caa:	00006517          	auipc	a0,0x6
    80000cae:	4ee50513          	addi	a0,a0,1262 # 80007198 <etext+0x198>
    80000cb2:	0b1040ef          	jal	80005562 <panic>

0000000080000cb6 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000cb6:	7139                	addi	sp,sp,-64
    80000cb8:	fc06                	sd	ra,56(sp)
    80000cba:	f822                	sd	s0,48(sp)
    80000cbc:	f426                	sd	s1,40(sp)
    80000cbe:	f04a                	sd	s2,32(sp)
    80000cc0:	ec4e                	sd	s3,24(sp)
    80000cc2:	e852                	sd	s4,16(sp)
    80000cc4:	e456                	sd	s5,8(sp)
    80000cc6:	e05a                	sd	s6,0(sp)
    80000cc8:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000cca:	00006597          	auipc	a1,0x6
    80000cce:	4d658593          	addi	a1,a1,1238 # 800071a0 <etext+0x1a0>
    80000cd2:	00009517          	auipc	a0,0x9
    80000cd6:	7ce50513          	addi	a0,a0,1998 # 8000a4a0 <pid_lock>
    80000cda:	337040ef          	jal	80005810 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000cde:	00006597          	auipc	a1,0x6
    80000ce2:	4ca58593          	addi	a1,a1,1226 # 800071a8 <etext+0x1a8>
    80000ce6:	00009517          	auipc	a0,0x9
    80000cea:	7d250513          	addi	a0,a0,2002 # 8000a4b8 <wait_lock>
    80000cee:	323040ef          	jal	80005810 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cf2:	0000a497          	auipc	s1,0xa
    80000cf6:	bde48493          	addi	s1,s1,-1058 # 8000a8d0 <proc>
      initlock(&p->lock, "proc");
    80000cfa:	00006b17          	auipc	s6,0x6
    80000cfe:	4beb0b13          	addi	s6,s6,1214 # 800071b8 <etext+0x1b8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000d02:	8aa6                	mv	s5,s1
    80000d04:	04fa5937          	lui	s2,0x4fa5
    80000d08:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80000d0c:	0932                	slli	s2,s2,0xc
    80000d0e:	fa590913          	addi	s2,s2,-91
    80000d12:	0932                	slli	s2,s2,0xc
    80000d14:	fa590913          	addi	s2,s2,-91
    80000d18:	0932                	slli	s2,s2,0xc
    80000d1a:	fa590913          	addi	s2,s2,-91
    80000d1e:	040009b7          	lui	s3,0x4000
    80000d22:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000d24:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d26:	0000fa17          	auipc	s4,0xf
    80000d2a:	5aaa0a13          	addi	s4,s4,1450 # 800102d0 <tickslock>
      initlock(&p->lock, "proc");
    80000d2e:	85da                	mv	a1,s6
    80000d30:	8526                	mv	a0,s1
    80000d32:	2df040ef          	jal	80005810 <initlock>
      p->state = UNUSED;
    80000d36:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000d3a:	415487b3          	sub	a5,s1,s5
    80000d3e:	878d                	srai	a5,a5,0x3
    80000d40:	032787b3          	mul	a5,a5,s2
    80000d44:	2785                	addiw	a5,a5,1
    80000d46:	00d7979b          	slliw	a5,a5,0xd
    80000d4a:	40f987b3          	sub	a5,s3,a5
    80000d4e:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d50:	16848493          	addi	s1,s1,360
    80000d54:	fd449de3          	bne	s1,s4,80000d2e <procinit+0x78>
  }
}
    80000d58:	70e2                	ld	ra,56(sp)
    80000d5a:	7442                	ld	s0,48(sp)
    80000d5c:	74a2                	ld	s1,40(sp)
    80000d5e:	7902                	ld	s2,32(sp)
    80000d60:	69e2                	ld	s3,24(sp)
    80000d62:	6a42                	ld	s4,16(sp)
    80000d64:	6aa2                	ld	s5,8(sp)
    80000d66:	6b02                	ld	s6,0(sp)
    80000d68:	6121                	addi	sp,sp,64
    80000d6a:	8082                	ret

0000000080000d6c <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000d6c:	1141                	addi	sp,sp,-16
    80000d6e:	e422                	sd	s0,8(sp)
    80000d70:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000d72:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000d74:	2501                	sext.w	a0,a0
    80000d76:	6422                	ld	s0,8(sp)
    80000d78:	0141                	addi	sp,sp,16
    80000d7a:	8082                	ret

0000000080000d7c <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000d7c:	1141                	addi	sp,sp,-16
    80000d7e:	e422                	sd	s0,8(sp)
    80000d80:	0800                	addi	s0,sp,16
    80000d82:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000d84:	2781                	sext.w	a5,a5
    80000d86:	079e                	slli	a5,a5,0x7
  return c;
}
    80000d88:	00009517          	auipc	a0,0x9
    80000d8c:	74850513          	addi	a0,a0,1864 # 8000a4d0 <cpus>
    80000d90:	953e                	add	a0,a0,a5
    80000d92:	6422                	ld	s0,8(sp)
    80000d94:	0141                	addi	sp,sp,16
    80000d96:	8082                	ret

0000000080000d98 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000d98:	1101                	addi	sp,sp,-32
    80000d9a:	ec06                	sd	ra,24(sp)
    80000d9c:	e822                	sd	s0,16(sp)
    80000d9e:	e426                	sd	s1,8(sp)
    80000da0:	1000                	addi	s0,sp,32
  push_off();
    80000da2:	2af040ef          	jal	80005850 <push_off>
    80000da6:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000da8:	2781                	sext.w	a5,a5
    80000daa:	079e                	slli	a5,a5,0x7
    80000dac:	00009717          	auipc	a4,0x9
    80000db0:	6f470713          	addi	a4,a4,1780 # 8000a4a0 <pid_lock>
    80000db4:	97ba                	add	a5,a5,a4
    80000db6:	7b84                	ld	s1,48(a5)
  pop_off();
    80000db8:	31d040ef          	jal	800058d4 <pop_off>
  return p;
}
    80000dbc:	8526                	mv	a0,s1
    80000dbe:	60e2                	ld	ra,24(sp)
    80000dc0:	6442                	ld	s0,16(sp)
    80000dc2:	64a2                	ld	s1,8(sp)
    80000dc4:	6105                	addi	sp,sp,32
    80000dc6:	8082                	ret

0000000080000dc8 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000dc8:	1141                	addi	sp,sp,-16
    80000dca:	e406                	sd	ra,8(sp)
    80000dcc:	e022                	sd	s0,0(sp)
    80000dce:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000dd0:	fc9ff0ef          	jal	80000d98 <myproc>
    80000dd4:	355040ef          	jal	80005928 <release>

  if (first) {
    80000dd8:	00009797          	auipc	a5,0x9
    80000ddc:	6087a783          	lw	a5,1544(a5) # 8000a3e0 <first.1>
    80000de0:	e799                	bnez	a5,80000dee <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80000de2:	30b000ef          	jal	800018ec <usertrapret>
}
    80000de6:	60a2                	ld	ra,8(sp)
    80000de8:	6402                	ld	s0,0(sp)
    80000dea:	0141                	addi	sp,sp,16
    80000dec:	8082                	ret
    fsinit(ROOTDEV);
    80000dee:	4505                	li	a0,1
    80000df0:	73e010ef          	jal	8000252e <fsinit>
    first = 0;
    80000df4:	00009797          	auipc	a5,0x9
    80000df8:	5e07a623          	sw	zero,1516(a5) # 8000a3e0 <first.1>
    __sync_synchronize();
    80000dfc:	0330000f          	fence	rw,rw
    80000e00:	b7cd                	j	80000de2 <forkret+0x1a>

0000000080000e02 <allocpid>:
{
    80000e02:	1101                	addi	sp,sp,-32
    80000e04:	ec06                	sd	ra,24(sp)
    80000e06:	e822                	sd	s0,16(sp)
    80000e08:	e426                	sd	s1,8(sp)
    80000e0a:	e04a                	sd	s2,0(sp)
    80000e0c:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000e0e:	00009917          	auipc	s2,0x9
    80000e12:	69290913          	addi	s2,s2,1682 # 8000a4a0 <pid_lock>
    80000e16:	854a                	mv	a0,s2
    80000e18:	279040ef          	jal	80005890 <acquire>
  pid = nextpid;
    80000e1c:	00009797          	auipc	a5,0x9
    80000e20:	5c878793          	addi	a5,a5,1480 # 8000a3e4 <nextpid>
    80000e24:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000e26:	0014871b          	addiw	a4,s1,1
    80000e2a:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000e2c:	854a                	mv	a0,s2
    80000e2e:	2fb040ef          	jal	80005928 <release>
}
    80000e32:	8526                	mv	a0,s1
    80000e34:	60e2                	ld	ra,24(sp)
    80000e36:	6442                	ld	s0,16(sp)
    80000e38:	64a2                	ld	s1,8(sp)
    80000e3a:	6902                	ld	s2,0(sp)
    80000e3c:	6105                	addi	sp,sp,32
    80000e3e:	8082                	ret

0000000080000e40 <proc_pagetable>:
{
    80000e40:	1101                	addi	sp,sp,-32
    80000e42:	ec06                	sd	ra,24(sp)
    80000e44:	e822                	sd	s0,16(sp)
    80000e46:	e426                	sd	s1,8(sp)
    80000e48:	e04a                	sd	s2,0(sp)
    80000e4a:	1000                	addi	s0,sp,32
    80000e4c:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000e4e:	8e7ff0ef          	jal	80000734 <uvmcreate>
    80000e52:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000e54:	cd05                	beqz	a0,80000e8c <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000e56:	4729                	li	a4,10
    80000e58:	00005697          	auipc	a3,0x5
    80000e5c:	1a868693          	addi	a3,a3,424 # 80006000 <_trampoline>
    80000e60:	6605                	lui	a2,0x1
    80000e62:	040005b7          	lui	a1,0x4000
    80000e66:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000e68:	05b2                	slli	a1,a1,0xc
    80000e6a:	e58ff0ef          	jal	800004c2 <mappages>
    80000e6e:	02054663          	bltz	a0,80000e9a <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000e72:	4719                	li	a4,6
    80000e74:	05893683          	ld	a3,88(s2)
    80000e78:	6605                	lui	a2,0x1
    80000e7a:	020005b7          	lui	a1,0x2000
    80000e7e:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000e80:	05b6                	slli	a1,a1,0xd
    80000e82:	8526                	mv	a0,s1
    80000e84:	e3eff0ef          	jal	800004c2 <mappages>
    80000e88:	00054f63          	bltz	a0,80000ea6 <proc_pagetable+0x66>
}
    80000e8c:	8526                	mv	a0,s1
    80000e8e:	60e2                	ld	ra,24(sp)
    80000e90:	6442                	ld	s0,16(sp)
    80000e92:	64a2                	ld	s1,8(sp)
    80000e94:	6902                	ld	s2,0(sp)
    80000e96:	6105                	addi	sp,sp,32
    80000e98:	8082                	ret
    uvmfree(pagetable, 0);
    80000e9a:	4581                	li	a1,0
    80000e9c:	8526                	mv	a0,s1
    80000e9e:	a5dff0ef          	jal	800008fa <uvmfree>
    return 0;
    80000ea2:	4481                	li	s1,0
    80000ea4:	b7e5                	j	80000e8c <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000ea6:	4681                	li	a3,0
    80000ea8:	4605                	li	a2,1
    80000eaa:	040005b7          	lui	a1,0x4000
    80000eae:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000eb0:	05b2                	slli	a1,a1,0xc
    80000eb2:	8526                	mv	a0,s1
    80000eb4:	fb4ff0ef          	jal	80000668 <uvmunmap>
    uvmfree(pagetable, 0);
    80000eb8:	4581                	li	a1,0
    80000eba:	8526                	mv	a0,s1
    80000ebc:	a3fff0ef          	jal	800008fa <uvmfree>
    return 0;
    80000ec0:	4481                	li	s1,0
    80000ec2:	b7e9                	j	80000e8c <proc_pagetable+0x4c>

0000000080000ec4 <proc_freepagetable>:
{
    80000ec4:	1101                	addi	sp,sp,-32
    80000ec6:	ec06                	sd	ra,24(sp)
    80000ec8:	e822                	sd	s0,16(sp)
    80000eca:	e426                	sd	s1,8(sp)
    80000ecc:	e04a                	sd	s2,0(sp)
    80000ece:	1000                	addi	s0,sp,32
    80000ed0:	84aa                	mv	s1,a0
    80000ed2:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000ed4:	4681                	li	a3,0
    80000ed6:	4605                	li	a2,1
    80000ed8:	040005b7          	lui	a1,0x4000
    80000edc:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000ede:	05b2                	slli	a1,a1,0xc
    80000ee0:	f88ff0ef          	jal	80000668 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000ee4:	4681                	li	a3,0
    80000ee6:	4605                	li	a2,1
    80000ee8:	020005b7          	lui	a1,0x2000
    80000eec:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000eee:	05b6                	slli	a1,a1,0xd
    80000ef0:	8526                	mv	a0,s1
    80000ef2:	f76ff0ef          	jal	80000668 <uvmunmap>
  uvmfree(pagetable, sz);
    80000ef6:	85ca                	mv	a1,s2
    80000ef8:	8526                	mv	a0,s1
    80000efa:	a01ff0ef          	jal	800008fa <uvmfree>
}
    80000efe:	60e2                	ld	ra,24(sp)
    80000f00:	6442                	ld	s0,16(sp)
    80000f02:	64a2                	ld	s1,8(sp)
    80000f04:	6902                	ld	s2,0(sp)
    80000f06:	6105                	addi	sp,sp,32
    80000f08:	8082                	ret

0000000080000f0a <freeproc>:
{
    80000f0a:	1101                	addi	sp,sp,-32
    80000f0c:	ec06                	sd	ra,24(sp)
    80000f0e:	e822                	sd	s0,16(sp)
    80000f10:	e426                	sd	s1,8(sp)
    80000f12:	1000                	addi	s0,sp,32
    80000f14:	84aa                	mv	s1,a0
  if(p->trapframe)
    80000f16:	6d28                	ld	a0,88(a0)
    80000f18:	c119                	beqz	a0,80000f1e <freeproc+0x14>
    kfree((void*)p->trapframe);
    80000f1a:	902ff0ef          	jal	8000001c <kfree>
  p->trapframe = 0;
    80000f1e:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80000f22:	68a8                	ld	a0,80(s1)
    80000f24:	c501                	beqz	a0,80000f2c <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80000f26:	64ac                	ld	a1,72(s1)
    80000f28:	f9dff0ef          	jal	80000ec4 <proc_freepagetable>
  p->pagetable = 0;
    80000f2c:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80000f30:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80000f34:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80000f38:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80000f3c:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80000f40:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80000f44:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80000f48:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80000f4c:	0004ac23          	sw	zero,24(s1)
}
    80000f50:	60e2                	ld	ra,24(sp)
    80000f52:	6442                	ld	s0,16(sp)
    80000f54:	64a2                	ld	s1,8(sp)
    80000f56:	6105                	addi	sp,sp,32
    80000f58:	8082                	ret

0000000080000f5a <allocproc>:
{
    80000f5a:	1101                	addi	sp,sp,-32
    80000f5c:	ec06                	sd	ra,24(sp)
    80000f5e:	e822                	sd	s0,16(sp)
    80000f60:	e426                	sd	s1,8(sp)
    80000f62:	e04a                	sd	s2,0(sp)
    80000f64:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f66:	0000a497          	auipc	s1,0xa
    80000f6a:	96a48493          	addi	s1,s1,-1686 # 8000a8d0 <proc>
    80000f6e:	0000f917          	auipc	s2,0xf
    80000f72:	36290913          	addi	s2,s2,866 # 800102d0 <tickslock>
    acquire(&p->lock);
    80000f76:	8526                	mv	a0,s1
    80000f78:	119040ef          	jal	80005890 <acquire>
    if(p->state == UNUSED) {
    80000f7c:	4c9c                	lw	a5,24(s1)
    80000f7e:	cb91                	beqz	a5,80000f92 <allocproc+0x38>
      release(&p->lock);
    80000f80:	8526                	mv	a0,s1
    80000f82:	1a7040ef          	jal	80005928 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f86:	16848493          	addi	s1,s1,360
    80000f8a:	ff2496e3          	bne	s1,s2,80000f76 <allocproc+0x1c>
  return 0;
    80000f8e:	4481                	li	s1,0
    80000f90:	a089                	j	80000fd2 <allocproc+0x78>
  p->pid = allocpid();
    80000f92:	e71ff0ef          	jal	80000e02 <allocpid>
    80000f96:	d888                	sw	a0,48(s1)
  p->state = USED;
    80000f98:	4785                	li	a5,1
    80000f9a:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80000f9c:	95aff0ef          	jal	800000f6 <kalloc>
    80000fa0:	892a                	mv	s2,a0
    80000fa2:	eca8                	sd	a0,88(s1)
    80000fa4:	cd15                	beqz	a0,80000fe0 <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80000fa6:	8526                	mv	a0,s1
    80000fa8:	e99ff0ef          	jal	80000e40 <proc_pagetable>
    80000fac:	892a                	mv	s2,a0
    80000fae:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80000fb0:	c121                	beqz	a0,80000ff0 <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    80000fb2:	07000613          	li	a2,112
    80000fb6:	4581                	li	a1,0
    80000fb8:	06048513          	addi	a0,s1,96
    80000fbc:	9baff0ef          	jal	80000176 <memset>
  p->context.ra = (uint64)forkret;
    80000fc0:	00000797          	auipc	a5,0x0
    80000fc4:	e0878793          	addi	a5,a5,-504 # 80000dc8 <forkret>
    80000fc8:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80000fca:	60bc                	ld	a5,64(s1)
    80000fcc:	6705                	lui	a4,0x1
    80000fce:	97ba                	add	a5,a5,a4
    80000fd0:	f4bc                	sd	a5,104(s1)
}
    80000fd2:	8526                	mv	a0,s1
    80000fd4:	60e2                	ld	ra,24(sp)
    80000fd6:	6442                	ld	s0,16(sp)
    80000fd8:	64a2                	ld	s1,8(sp)
    80000fda:	6902                	ld	s2,0(sp)
    80000fdc:	6105                	addi	sp,sp,32
    80000fde:	8082                	ret
    freeproc(p);
    80000fe0:	8526                	mv	a0,s1
    80000fe2:	f29ff0ef          	jal	80000f0a <freeproc>
    release(&p->lock);
    80000fe6:	8526                	mv	a0,s1
    80000fe8:	141040ef          	jal	80005928 <release>
    return 0;
    80000fec:	84ca                	mv	s1,s2
    80000fee:	b7d5                	j	80000fd2 <allocproc+0x78>
    freeproc(p);
    80000ff0:	8526                	mv	a0,s1
    80000ff2:	f19ff0ef          	jal	80000f0a <freeproc>
    release(&p->lock);
    80000ff6:	8526                	mv	a0,s1
    80000ff8:	131040ef          	jal	80005928 <release>
    return 0;
    80000ffc:	84ca                	mv	s1,s2
    80000ffe:	bfd1                	j	80000fd2 <allocproc+0x78>

0000000080001000 <userinit>:
{
    80001000:	1101                	addi	sp,sp,-32
    80001002:	ec06                	sd	ra,24(sp)
    80001004:	e822                	sd	s0,16(sp)
    80001006:	e426                	sd	s1,8(sp)
    80001008:	1000                	addi	s0,sp,32
  p = allocproc();
    8000100a:	f51ff0ef          	jal	80000f5a <allocproc>
    8000100e:	84aa                	mv	s1,a0
  initproc = p;
    80001010:	00009797          	auipc	a5,0x9
    80001014:	44a7b823          	sd	a0,1104(a5) # 8000a460 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001018:	03400613          	li	a2,52
    8000101c:	00009597          	auipc	a1,0x9
    80001020:	3d458593          	addi	a1,a1,980 # 8000a3f0 <initcode>
    80001024:	6928                	ld	a0,80(a0)
    80001026:	f34ff0ef          	jal	8000075a <uvmfirst>
  p->sz = PGSIZE;
    8000102a:	6785                	lui	a5,0x1
    8000102c:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    8000102e:	6cb8                	ld	a4,88(s1)
    80001030:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001034:	6cb8                	ld	a4,88(s1)
    80001036:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001038:	4641                	li	a2,16
    8000103a:	00006597          	auipc	a1,0x6
    8000103e:	18658593          	addi	a1,a1,390 # 800071c0 <etext+0x1c0>
    80001042:	15848513          	addi	a0,s1,344
    80001046:	a6eff0ef          	jal	800002b4 <safestrcpy>
  p->cwd = namei("/");
    8000104a:	00006517          	auipc	a0,0x6
    8000104e:	18650513          	addi	a0,a0,390 # 800071d0 <etext+0x1d0>
    80001052:	5eb010ef          	jal	80002e3c <namei>
    80001056:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000105a:	478d                	li	a5,3
    8000105c:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000105e:	8526                	mv	a0,s1
    80001060:	0c9040ef          	jal	80005928 <release>
}
    80001064:	60e2                	ld	ra,24(sp)
    80001066:	6442                	ld	s0,16(sp)
    80001068:	64a2                	ld	s1,8(sp)
    8000106a:	6105                	addi	sp,sp,32
    8000106c:	8082                	ret

000000008000106e <growproc>:
{
    8000106e:	1101                	addi	sp,sp,-32
    80001070:	ec06                	sd	ra,24(sp)
    80001072:	e822                	sd	s0,16(sp)
    80001074:	e426                	sd	s1,8(sp)
    80001076:	e04a                	sd	s2,0(sp)
    80001078:	1000                	addi	s0,sp,32
    8000107a:	892a                	mv	s2,a0
  struct proc *p = myproc();
    8000107c:	d1dff0ef          	jal	80000d98 <myproc>
    80001080:	84aa                	mv	s1,a0
  sz = p->sz;
    80001082:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001084:	01204c63          	bgtz	s2,8000109c <growproc+0x2e>
  } else if(n < 0){
    80001088:	02094463          	bltz	s2,800010b0 <growproc+0x42>
  p->sz = sz;
    8000108c:	e4ac                	sd	a1,72(s1)
  return 0;
    8000108e:	4501                	li	a0,0
}
    80001090:	60e2                	ld	ra,24(sp)
    80001092:	6442                	ld	s0,16(sp)
    80001094:	64a2                	ld	s1,8(sp)
    80001096:	6902                	ld	s2,0(sp)
    80001098:	6105                	addi	sp,sp,32
    8000109a:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    8000109c:	4691                	li	a3,4
    8000109e:	00b90633          	add	a2,s2,a1
    800010a2:	6928                	ld	a0,80(a0)
    800010a4:	f58ff0ef          	jal	800007fc <uvmalloc>
    800010a8:	85aa                	mv	a1,a0
    800010aa:	f16d                	bnez	a0,8000108c <growproc+0x1e>
      return -1;
    800010ac:	557d                	li	a0,-1
    800010ae:	b7cd                	j	80001090 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800010b0:	00b90633          	add	a2,s2,a1
    800010b4:	6928                	ld	a0,80(a0)
    800010b6:	f02ff0ef          	jal	800007b8 <uvmdealloc>
    800010ba:	85aa                	mv	a1,a0
    800010bc:	bfc1                	j	8000108c <growproc+0x1e>

00000000800010be <fork>:
{
    800010be:	7139                	addi	sp,sp,-64
    800010c0:	fc06                	sd	ra,56(sp)
    800010c2:	f822                	sd	s0,48(sp)
    800010c4:	f04a                	sd	s2,32(sp)
    800010c6:	e456                	sd	s5,8(sp)
    800010c8:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800010ca:	ccfff0ef          	jal	80000d98 <myproc>
    800010ce:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    800010d0:	e8bff0ef          	jal	80000f5a <allocproc>
    800010d4:	0e050a63          	beqz	a0,800011c8 <fork+0x10a>
    800010d8:	e852                	sd	s4,16(sp)
    800010da:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800010dc:	048ab603          	ld	a2,72(s5)
    800010e0:	692c                	ld	a1,80(a0)
    800010e2:	050ab503          	ld	a0,80(s5)
    800010e6:	847ff0ef          	jal	8000092c <uvmcopy>
    800010ea:	04054a63          	bltz	a0,8000113e <fork+0x80>
    800010ee:	f426                	sd	s1,40(sp)
    800010f0:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    800010f2:	048ab783          	ld	a5,72(s5)
    800010f6:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    800010fa:	058ab683          	ld	a3,88(s5)
    800010fe:	87b6                	mv	a5,a3
    80001100:	058a3703          	ld	a4,88(s4)
    80001104:	12068693          	addi	a3,a3,288
    80001108:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000110c:	6788                	ld	a0,8(a5)
    8000110e:	6b8c                	ld	a1,16(a5)
    80001110:	6f90                	ld	a2,24(a5)
    80001112:	01073023          	sd	a6,0(a4)
    80001116:	e708                	sd	a0,8(a4)
    80001118:	eb0c                	sd	a1,16(a4)
    8000111a:	ef10                	sd	a2,24(a4)
    8000111c:	02078793          	addi	a5,a5,32
    80001120:	02070713          	addi	a4,a4,32
    80001124:	fed792e3          	bne	a5,a3,80001108 <fork+0x4a>
  np->trapframe->a0 = 0;
    80001128:	058a3783          	ld	a5,88(s4)
    8000112c:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001130:	0d0a8493          	addi	s1,s5,208
    80001134:	0d0a0913          	addi	s2,s4,208
    80001138:	150a8993          	addi	s3,s5,336
    8000113c:	a831                	j	80001158 <fork+0x9a>
    freeproc(np);
    8000113e:	8552                	mv	a0,s4
    80001140:	dcbff0ef          	jal	80000f0a <freeproc>
    release(&np->lock);
    80001144:	8552                	mv	a0,s4
    80001146:	7e2040ef          	jal	80005928 <release>
    return -1;
    8000114a:	597d                	li	s2,-1
    8000114c:	6a42                	ld	s4,16(sp)
    8000114e:	a0b5                	j	800011ba <fork+0xfc>
  for(i = 0; i < NOFILE; i++)
    80001150:	04a1                	addi	s1,s1,8
    80001152:	0921                	addi	s2,s2,8
    80001154:	01348963          	beq	s1,s3,80001166 <fork+0xa8>
    if(p->ofile[i])
    80001158:	6088                	ld	a0,0(s1)
    8000115a:	d97d                	beqz	a0,80001150 <fork+0x92>
      np->ofile[i] = filedup(p->ofile[i]);
    8000115c:	270020ef          	jal	800033cc <filedup>
    80001160:	00a93023          	sd	a0,0(s2)
    80001164:	b7f5                	j	80001150 <fork+0x92>
  np->cwd = idup(p->cwd);
    80001166:	150ab503          	ld	a0,336(s5)
    8000116a:	5c2010ef          	jal	8000272c <idup>
    8000116e:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001172:	4641                	li	a2,16
    80001174:	158a8593          	addi	a1,s5,344
    80001178:	158a0513          	addi	a0,s4,344
    8000117c:	938ff0ef          	jal	800002b4 <safestrcpy>
  pid = np->pid;
    80001180:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001184:	8552                	mv	a0,s4
    80001186:	7a2040ef          	jal	80005928 <release>
  acquire(&wait_lock);
    8000118a:	00009497          	auipc	s1,0x9
    8000118e:	32e48493          	addi	s1,s1,814 # 8000a4b8 <wait_lock>
    80001192:	8526                	mv	a0,s1
    80001194:	6fc040ef          	jal	80005890 <acquire>
  np->parent = p;
    80001198:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    8000119c:	8526                	mv	a0,s1
    8000119e:	78a040ef          	jal	80005928 <release>
  acquire(&np->lock);
    800011a2:	8552                	mv	a0,s4
    800011a4:	6ec040ef          	jal	80005890 <acquire>
  np->state = RUNNABLE;
    800011a8:	478d                	li	a5,3
    800011aa:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    800011ae:	8552                	mv	a0,s4
    800011b0:	778040ef          	jal	80005928 <release>
  return pid;
    800011b4:	74a2                	ld	s1,40(sp)
    800011b6:	69e2                	ld	s3,24(sp)
    800011b8:	6a42                	ld	s4,16(sp)
}
    800011ba:	854a                	mv	a0,s2
    800011bc:	70e2                	ld	ra,56(sp)
    800011be:	7442                	ld	s0,48(sp)
    800011c0:	7902                	ld	s2,32(sp)
    800011c2:	6aa2                	ld	s5,8(sp)
    800011c4:	6121                	addi	sp,sp,64
    800011c6:	8082                	ret
    return -1;
    800011c8:	597d                	li	s2,-1
    800011ca:	bfc5                	j	800011ba <fork+0xfc>

00000000800011cc <scheduler>:
{
    800011cc:	715d                	addi	sp,sp,-80
    800011ce:	e486                	sd	ra,72(sp)
    800011d0:	e0a2                	sd	s0,64(sp)
    800011d2:	fc26                	sd	s1,56(sp)
    800011d4:	f84a                	sd	s2,48(sp)
    800011d6:	f44e                	sd	s3,40(sp)
    800011d8:	f052                	sd	s4,32(sp)
    800011da:	ec56                	sd	s5,24(sp)
    800011dc:	e85a                	sd	s6,16(sp)
    800011de:	e45e                	sd	s7,8(sp)
    800011e0:	e062                	sd	s8,0(sp)
    800011e2:	0880                	addi	s0,sp,80
    800011e4:	8792                	mv	a5,tp
  int id = r_tp();
    800011e6:	2781                	sext.w	a5,a5
  c->proc = 0;
    800011e8:	00779b13          	slli	s6,a5,0x7
    800011ec:	00009717          	auipc	a4,0x9
    800011f0:	2b470713          	addi	a4,a4,692 # 8000a4a0 <pid_lock>
    800011f4:	975a                	add	a4,a4,s6
    800011f6:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800011fa:	00009717          	auipc	a4,0x9
    800011fe:	2de70713          	addi	a4,a4,734 # 8000a4d8 <cpus+0x8>
    80001202:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80001204:	4c11                	li	s8,4
        c->proc = p;
    80001206:	079e                	slli	a5,a5,0x7
    80001208:	00009a17          	auipc	s4,0x9
    8000120c:	298a0a13          	addi	s4,s4,664 # 8000a4a0 <pid_lock>
    80001210:	9a3e                	add	s4,s4,a5
        found = 1;
    80001212:	4b85                	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    80001214:	0000f997          	auipc	s3,0xf
    80001218:	0bc98993          	addi	s3,s3,188 # 800102d0 <tickslock>
    8000121c:	a0a9                	j	80001266 <scheduler+0x9a>
      release(&p->lock);
    8000121e:	8526                	mv	a0,s1
    80001220:	708040ef          	jal	80005928 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001224:	16848493          	addi	s1,s1,360
    80001228:	03348563          	beq	s1,s3,80001252 <scheduler+0x86>
      acquire(&p->lock);
    8000122c:	8526                	mv	a0,s1
    8000122e:	662040ef          	jal	80005890 <acquire>
      if(p->state == RUNNABLE) {
    80001232:	4c9c                	lw	a5,24(s1)
    80001234:	ff2795e3          	bne	a5,s2,8000121e <scheduler+0x52>
        p->state = RUNNING;
    80001238:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    8000123c:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001240:	06048593          	addi	a1,s1,96
    80001244:	855a                	mv	a0,s6
    80001246:	600000ef          	jal	80001846 <swtch>
        c->proc = 0;
    8000124a:	020a3823          	sd	zero,48(s4)
        found = 1;
    8000124e:	8ade                	mv	s5,s7
    80001250:	b7f9                	j	8000121e <scheduler+0x52>
    if(found == 0) {
    80001252:	000a9a63          	bnez	s5,80001266 <scheduler+0x9a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001256:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000125a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000125e:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80001262:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001266:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000126a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000126e:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001272:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001274:	00009497          	auipc	s1,0x9
    80001278:	65c48493          	addi	s1,s1,1628 # 8000a8d0 <proc>
      if(p->state == RUNNABLE) {
    8000127c:	490d                	li	s2,3
    8000127e:	b77d                	j	8000122c <scheduler+0x60>

0000000080001280 <sched>:
{
    80001280:	7179                	addi	sp,sp,-48
    80001282:	f406                	sd	ra,40(sp)
    80001284:	f022                	sd	s0,32(sp)
    80001286:	ec26                	sd	s1,24(sp)
    80001288:	e84a                	sd	s2,16(sp)
    8000128a:	e44e                	sd	s3,8(sp)
    8000128c:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000128e:	b0bff0ef          	jal	80000d98 <myproc>
    80001292:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001294:	592040ef          	jal	80005826 <holding>
    80001298:	c92d                	beqz	a0,8000130a <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000129a:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000129c:	2781                	sext.w	a5,a5
    8000129e:	079e                	slli	a5,a5,0x7
    800012a0:	00009717          	auipc	a4,0x9
    800012a4:	20070713          	addi	a4,a4,512 # 8000a4a0 <pid_lock>
    800012a8:	97ba                	add	a5,a5,a4
    800012aa:	0a87a703          	lw	a4,168(a5)
    800012ae:	4785                	li	a5,1
    800012b0:	06f71363          	bne	a4,a5,80001316 <sched+0x96>
  if(p->state == RUNNING)
    800012b4:	4c98                	lw	a4,24(s1)
    800012b6:	4791                	li	a5,4
    800012b8:	06f70563          	beq	a4,a5,80001322 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800012bc:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800012c0:	8b89                	andi	a5,a5,2
  if(intr_get())
    800012c2:	e7b5                	bnez	a5,8000132e <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    800012c4:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800012c6:	00009917          	auipc	s2,0x9
    800012ca:	1da90913          	addi	s2,s2,474 # 8000a4a0 <pid_lock>
    800012ce:	2781                	sext.w	a5,a5
    800012d0:	079e                	slli	a5,a5,0x7
    800012d2:	97ca                	add	a5,a5,s2
    800012d4:	0ac7a983          	lw	s3,172(a5)
    800012d8:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800012da:	2781                	sext.w	a5,a5
    800012dc:	079e                	slli	a5,a5,0x7
    800012de:	00009597          	auipc	a1,0x9
    800012e2:	1fa58593          	addi	a1,a1,506 # 8000a4d8 <cpus+0x8>
    800012e6:	95be                	add	a1,a1,a5
    800012e8:	06048513          	addi	a0,s1,96
    800012ec:	55a000ef          	jal	80001846 <swtch>
    800012f0:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800012f2:	2781                	sext.w	a5,a5
    800012f4:	079e                	slli	a5,a5,0x7
    800012f6:	993e                	add	s2,s2,a5
    800012f8:	0b392623          	sw	s3,172(s2)
}
    800012fc:	70a2                	ld	ra,40(sp)
    800012fe:	7402                	ld	s0,32(sp)
    80001300:	64e2                	ld	s1,24(sp)
    80001302:	6942                	ld	s2,16(sp)
    80001304:	69a2                	ld	s3,8(sp)
    80001306:	6145                	addi	sp,sp,48
    80001308:	8082                	ret
    panic("sched p->lock");
    8000130a:	00006517          	auipc	a0,0x6
    8000130e:	ece50513          	addi	a0,a0,-306 # 800071d8 <etext+0x1d8>
    80001312:	250040ef          	jal	80005562 <panic>
    panic("sched locks");
    80001316:	00006517          	auipc	a0,0x6
    8000131a:	ed250513          	addi	a0,a0,-302 # 800071e8 <etext+0x1e8>
    8000131e:	244040ef          	jal	80005562 <panic>
    panic("sched running");
    80001322:	00006517          	auipc	a0,0x6
    80001326:	ed650513          	addi	a0,a0,-298 # 800071f8 <etext+0x1f8>
    8000132a:	238040ef          	jal	80005562 <panic>
    panic("sched interruptible");
    8000132e:	00006517          	auipc	a0,0x6
    80001332:	eda50513          	addi	a0,a0,-294 # 80007208 <etext+0x208>
    80001336:	22c040ef          	jal	80005562 <panic>

000000008000133a <yield>:
{
    8000133a:	1101                	addi	sp,sp,-32
    8000133c:	ec06                	sd	ra,24(sp)
    8000133e:	e822                	sd	s0,16(sp)
    80001340:	e426                	sd	s1,8(sp)
    80001342:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001344:	a55ff0ef          	jal	80000d98 <myproc>
    80001348:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000134a:	546040ef          	jal	80005890 <acquire>
  p->state = RUNNABLE;
    8000134e:	478d                	li	a5,3
    80001350:	cc9c                	sw	a5,24(s1)
  sched();
    80001352:	f2fff0ef          	jal	80001280 <sched>
  release(&p->lock);
    80001356:	8526                	mv	a0,s1
    80001358:	5d0040ef          	jal	80005928 <release>
}
    8000135c:	60e2                	ld	ra,24(sp)
    8000135e:	6442                	ld	s0,16(sp)
    80001360:	64a2                	ld	s1,8(sp)
    80001362:	6105                	addi	sp,sp,32
    80001364:	8082                	ret

0000000080001366 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001366:	7179                	addi	sp,sp,-48
    80001368:	f406                	sd	ra,40(sp)
    8000136a:	f022                	sd	s0,32(sp)
    8000136c:	ec26                	sd	s1,24(sp)
    8000136e:	e84a                	sd	s2,16(sp)
    80001370:	e44e                	sd	s3,8(sp)
    80001372:	1800                	addi	s0,sp,48
    80001374:	89aa                	mv	s3,a0
    80001376:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001378:	a21ff0ef          	jal	80000d98 <myproc>
    8000137c:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000137e:	512040ef          	jal	80005890 <acquire>
  release(lk);
    80001382:	854a                	mv	a0,s2
    80001384:	5a4040ef          	jal	80005928 <release>

  // Go to sleep.
  p->chan = chan;
    80001388:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000138c:	4789                	li	a5,2
    8000138e:	cc9c                	sw	a5,24(s1)

  sched();
    80001390:	ef1ff0ef          	jal	80001280 <sched>

  // Tidy up.
  p->chan = 0;
    80001394:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001398:	8526                	mv	a0,s1
    8000139a:	58e040ef          	jal	80005928 <release>
  acquire(lk);
    8000139e:	854a                	mv	a0,s2
    800013a0:	4f0040ef          	jal	80005890 <acquire>
}
    800013a4:	70a2                	ld	ra,40(sp)
    800013a6:	7402                	ld	s0,32(sp)
    800013a8:	64e2                	ld	s1,24(sp)
    800013aa:	6942                	ld	s2,16(sp)
    800013ac:	69a2                	ld	s3,8(sp)
    800013ae:	6145                	addi	sp,sp,48
    800013b0:	8082                	ret

00000000800013b2 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800013b2:	7139                	addi	sp,sp,-64
    800013b4:	fc06                	sd	ra,56(sp)
    800013b6:	f822                	sd	s0,48(sp)
    800013b8:	f426                	sd	s1,40(sp)
    800013ba:	f04a                	sd	s2,32(sp)
    800013bc:	ec4e                	sd	s3,24(sp)
    800013be:	e852                	sd	s4,16(sp)
    800013c0:	e456                	sd	s5,8(sp)
    800013c2:	0080                	addi	s0,sp,64
    800013c4:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800013c6:	00009497          	auipc	s1,0x9
    800013ca:	50a48493          	addi	s1,s1,1290 # 8000a8d0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800013ce:	4989                	li	s3,2
        p->state = RUNNABLE;
    800013d0:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800013d2:	0000f917          	auipc	s2,0xf
    800013d6:	efe90913          	addi	s2,s2,-258 # 800102d0 <tickslock>
    800013da:	a801                	j	800013ea <wakeup+0x38>
      }
      release(&p->lock);
    800013dc:	8526                	mv	a0,s1
    800013de:	54a040ef          	jal	80005928 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800013e2:	16848493          	addi	s1,s1,360
    800013e6:	03248263          	beq	s1,s2,8000140a <wakeup+0x58>
    if(p != myproc()){
    800013ea:	9afff0ef          	jal	80000d98 <myproc>
    800013ee:	fea48ae3          	beq	s1,a0,800013e2 <wakeup+0x30>
      acquire(&p->lock);
    800013f2:	8526                	mv	a0,s1
    800013f4:	49c040ef          	jal	80005890 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800013f8:	4c9c                	lw	a5,24(s1)
    800013fa:	ff3791e3          	bne	a5,s3,800013dc <wakeup+0x2a>
    800013fe:	709c                	ld	a5,32(s1)
    80001400:	fd479ee3          	bne	a5,s4,800013dc <wakeup+0x2a>
        p->state = RUNNABLE;
    80001404:	0154ac23          	sw	s5,24(s1)
    80001408:	bfd1                	j	800013dc <wakeup+0x2a>
    }
  }
}
    8000140a:	70e2                	ld	ra,56(sp)
    8000140c:	7442                	ld	s0,48(sp)
    8000140e:	74a2                	ld	s1,40(sp)
    80001410:	7902                	ld	s2,32(sp)
    80001412:	69e2                	ld	s3,24(sp)
    80001414:	6a42                	ld	s4,16(sp)
    80001416:	6aa2                	ld	s5,8(sp)
    80001418:	6121                	addi	sp,sp,64
    8000141a:	8082                	ret

000000008000141c <reparent>:
{
    8000141c:	7179                	addi	sp,sp,-48
    8000141e:	f406                	sd	ra,40(sp)
    80001420:	f022                	sd	s0,32(sp)
    80001422:	ec26                	sd	s1,24(sp)
    80001424:	e84a                	sd	s2,16(sp)
    80001426:	e44e                	sd	s3,8(sp)
    80001428:	e052                	sd	s4,0(sp)
    8000142a:	1800                	addi	s0,sp,48
    8000142c:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000142e:	00009497          	auipc	s1,0x9
    80001432:	4a248493          	addi	s1,s1,1186 # 8000a8d0 <proc>
      pp->parent = initproc;
    80001436:	00009a17          	auipc	s4,0x9
    8000143a:	02aa0a13          	addi	s4,s4,42 # 8000a460 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000143e:	0000f997          	auipc	s3,0xf
    80001442:	e9298993          	addi	s3,s3,-366 # 800102d0 <tickslock>
    80001446:	a029                	j	80001450 <reparent+0x34>
    80001448:	16848493          	addi	s1,s1,360
    8000144c:	01348b63          	beq	s1,s3,80001462 <reparent+0x46>
    if(pp->parent == p){
    80001450:	7c9c                	ld	a5,56(s1)
    80001452:	ff279be3          	bne	a5,s2,80001448 <reparent+0x2c>
      pp->parent = initproc;
    80001456:	000a3503          	ld	a0,0(s4)
    8000145a:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000145c:	f57ff0ef          	jal	800013b2 <wakeup>
    80001460:	b7e5                	j	80001448 <reparent+0x2c>
}
    80001462:	70a2                	ld	ra,40(sp)
    80001464:	7402                	ld	s0,32(sp)
    80001466:	64e2                	ld	s1,24(sp)
    80001468:	6942                	ld	s2,16(sp)
    8000146a:	69a2                	ld	s3,8(sp)
    8000146c:	6a02                	ld	s4,0(sp)
    8000146e:	6145                	addi	sp,sp,48
    80001470:	8082                	ret

0000000080001472 <exit>:
{
    80001472:	7179                	addi	sp,sp,-48
    80001474:	f406                	sd	ra,40(sp)
    80001476:	f022                	sd	s0,32(sp)
    80001478:	ec26                	sd	s1,24(sp)
    8000147a:	e84a                	sd	s2,16(sp)
    8000147c:	e44e                	sd	s3,8(sp)
    8000147e:	e052                	sd	s4,0(sp)
    80001480:	1800                	addi	s0,sp,48
    80001482:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001484:	915ff0ef          	jal	80000d98 <myproc>
    80001488:	89aa                	mv	s3,a0
  if(p == initproc)
    8000148a:	00009797          	auipc	a5,0x9
    8000148e:	fd67b783          	ld	a5,-42(a5) # 8000a460 <initproc>
    80001492:	0d050493          	addi	s1,a0,208
    80001496:	15050913          	addi	s2,a0,336
    8000149a:	00a79f63          	bne	a5,a0,800014b8 <exit+0x46>
    panic("init exiting");
    8000149e:	00006517          	auipc	a0,0x6
    800014a2:	d8250513          	addi	a0,a0,-638 # 80007220 <etext+0x220>
    800014a6:	0bc040ef          	jal	80005562 <panic>
      fileclose(f);
    800014aa:	769010ef          	jal	80003412 <fileclose>
      p->ofile[fd] = 0;
    800014ae:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800014b2:	04a1                	addi	s1,s1,8
    800014b4:	01248563          	beq	s1,s2,800014be <exit+0x4c>
    if(p->ofile[fd]){
    800014b8:	6088                	ld	a0,0(s1)
    800014ba:	f965                	bnez	a0,800014aa <exit+0x38>
    800014bc:	bfdd                	j	800014b2 <exit+0x40>
  begin_op();
    800014be:	33b010ef          	jal	80002ff8 <begin_op>
  iput(p->cwd);
    800014c2:	1509b503          	ld	a0,336(s3)
    800014c6:	41e010ef          	jal	800028e4 <iput>
  end_op();
    800014ca:	399010ef          	jal	80003062 <end_op>
  p->cwd = 0;
    800014ce:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800014d2:	00009497          	auipc	s1,0x9
    800014d6:	fe648493          	addi	s1,s1,-26 # 8000a4b8 <wait_lock>
    800014da:	8526                	mv	a0,s1
    800014dc:	3b4040ef          	jal	80005890 <acquire>
  reparent(p);
    800014e0:	854e                	mv	a0,s3
    800014e2:	f3bff0ef          	jal	8000141c <reparent>
  wakeup(p->parent);
    800014e6:	0389b503          	ld	a0,56(s3)
    800014ea:	ec9ff0ef          	jal	800013b2 <wakeup>
  acquire(&p->lock);
    800014ee:	854e                	mv	a0,s3
    800014f0:	3a0040ef          	jal	80005890 <acquire>
  p->xstate = status;
    800014f4:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800014f8:	4795                	li	a5,5
    800014fa:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800014fe:	8526                	mv	a0,s1
    80001500:	428040ef          	jal	80005928 <release>
  sched();
    80001504:	d7dff0ef          	jal	80001280 <sched>
  panic("zombie exit");
    80001508:	00006517          	auipc	a0,0x6
    8000150c:	d2850513          	addi	a0,a0,-728 # 80007230 <etext+0x230>
    80001510:	052040ef          	jal	80005562 <panic>

0000000080001514 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001514:	7179                	addi	sp,sp,-48
    80001516:	f406                	sd	ra,40(sp)
    80001518:	f022                	sd	s0,32(sp)
    8000151a:	ec26                	sd	s1,24(sp)
    8000151c:	e84a                	sd	s2,16(sp)
    8000151e:	e44e                	sd	s3,8(sp)
    80001520:	1800                	addi	s0,sp,48
    80001522:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001524:	00009497          	auipc	s1,0x9
    80001528:	3ac48493          	addi	s1,s1,940 # 8000a8d0 <proc>
    8000152c:	0000f997          	auipc	s3,0xf
    80001530:	da498993          	addi	s3,s3,-604 # 800102d0 <tickslock>
    acquire(&p->lock);
    80001534:	8526                	mv	a0,s1
    80001536:	35a040ef          	jal	80005890 <acquire>
    if(p->pid == pid){
    8000153a:	589c                	lw	a5,48(s1)
    8000153c:	01278b63          	beq	a5,s2,80001552 <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001540:	8526                	mv	a0,s1
    80001542:	3e6040ef          	jal	80005928 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001546:	16848493          	addi	s1,s1,360
    8000154a:	ff3495e3          	bne	s1,s3,80001534 <kill+0x20>
  }
  return -1;
    8000154e:	557d                	li	a0,-1
    80001550:	a819                	j	80001566 <kill+0x52>
      p->killed = 1;
    80001552:	4785                	li	a5,1
    80001554:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001556:	4c98                	lw	a4,24(s1)
    80001558:	4789                	li	a5,2
    8000155a:	00f70d63          	beq	a4,a5,80001574 <kill+0x60>
      release(&p->lock);
    8000155e:	8526                	mv	a0,s1
    80001560:	3c8040ef          	jal	80005928 <release>
      return 0;
    80001564:	4501                	li	a0,0
}
    80001566:	70a2                	ld	ra,40(sp)
    80001568:	7402                	ld	s0,32(sp)
    8000156a:	64e2                	ld	s1,24(sp)
    8000156c:	6942                	ld	s2,16(sp)
    8000156e:	69a2                	ld	s3,8(sp)
    80001570:	6145                	addi	sp,sp,48
    80001572:	8082                	ret
        p->state = RUNNABLE;
    80001574:	478d                	li	a5,3
    80001576:	cc9c                	sw	a5,24(s1)
    80001578:	b7dd                	j	8000155e <kill+0x4a>

000000008000157a <setkilled>:

void
setkilled(struct proc *p)
{
    8000157a:	1101                	addi	sp,sp,-32
    8000157c:	ec06                	sd	ra,24(sp)
    8000157e:	e822                	sd	s0,16(sp)
    80001580:	e426                	sd	s1,8(sp)
    80001582:	1000                	addi	s0,sp,32
    80001584:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001586:	30a040ef          	jal	80005890 <acquire>
  p->killed = 1;
    8000158a:	4785                	li	a5,1
    8000158c:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    8000158e:	8526                	mv	a0,s1
    80001590:	398040ef          	jal	80005928 <release>
}
    80001594:	60e2                	ld	ra,24(sp)
    80001596:	6442                	ld	s0,16(sp)
    80001598:	64a2                	ld	s1,8(sp)
    8000159a:	6105                	addi	sp,sp,32
    8000159c:	8082                	ret

000000008000159e <killed>:

int
killed(struct proc *p)
{
    8000159e:	1101                	addi	sp,sp,-32
    800015a0:	ec06                	sd	ra,24(sp)
    800015a2:	e822                	sd	s0,16(sp)
    800015a4:	e426                	sd	s1,8(sp)
    800015a6:	e04a                	sd	s2,0(sp)
    800015a8:	1000                	addi	s0,sp,32
    800015aa:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800015ac:	2e4040ef          	jal	80005890 <acquire>
  k = p->killed;
    800015b0:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800015b4:	8526                	mv	a0,s1
    800015b6:	372040ef          	jal	80005928 <release>
  return k;
}
    800015ba:	854a                	mv	a0,s2
    800015bc:	60e2                	ld	ra,24(sp)
    800015be:	6442                	ld	s0,16(sp)
    800015c0:	64a2                	ld	s1,8(sp)
    800015c2:	6902                	ld	s2,0(sp)
    800015c4:	6105                	addi	sp,sp,32
    800015c6:	8082                	ret

00000000800015c8 <wait>:
{
    800015c8:	715d                	addi	sp,sp,-80
    800015ca:	e486                	sd	ra,72(sp)
    800015cc:	e0a2                	sd	s0,64(sp)
    800015ce:	fc26                	sd	s1,56(sp)
    800015d0:	f84a                	sd	s2,48(sp)
    800015d2:	f44e                	sd	s3,40(sp)
    800015d4:	f052                	sd	s4,32(sp)
    800015d6:	ec56                	sd	s5,24(sp)
    800015d8:	e85a                	sd	s6,16(sp)
    800015da:	e45e                	sd	s7,8(sp)
    800015dc:	e062                	sd	s8,0(sp)
    800015de:	0880                	addi	s0,sp,80
    800015e0:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015e2:	fb6ff0ef          	jal	80000d98 <myproc>
    800015e6:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015e8:	00009517          	auipc	a0,0x9
    800015ec:	ed050513          	addi	a0,a0,-304 # 8000a4b8 <wait_lock>
    800015f0:	2a0040ef          	jal	80005890 <acquire>
    havekids = 0;
    800015f4:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    800015f6:	4a15                	li	s4,5
        havekids = 1;
    800015f8:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800015fa:	0000f997          	auipc	s3,0xf
    800015fe:	cd698993          	addi	s3,s3,-810 # 800102d0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001602:	00009c17          	auipc	s8,0x9
    80001606:	eb6c0c13          	addi	s8,s8,-330 # 8000a4b8 <wait_lock>
    8000160a:	a871                	j	800016a6 <wait+0xde>
          pid = pp->pid;
    8000160c:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001610:	000b0c63          	beqz	s6,80001628 <wait+0x60>
    80001614:	4691                	li	a3,4
    80001616:	02c48613          	addi	a2,s1,44
    8000161a:	85da                	mv	a1,s6
    8000161c:	05093503          	ld	a0,80(s2)
    80001620:	be8ff0ef          	jal	80000a08 <copyout>
    80001624:	02054b63          	bltz	a0,8000165a <wait+0x92>
          freeproc(pp);
    80001628:	8526                	mv	a0,s1
    8000162a:	8e1ff0ef          	jal	80000f0a <freeproc>
          release(&pp->lock);
    8000162e:	8526                	mv	a0,s1
    80001630:	2f8040ef          	jal	80005928 <release>
          release(&wait_lock);
    80001634:	00009517          	auipc	a0,0x9
    80001638:	e8450513          	addi	a0,a0,-380 # 8000a4b8 <wait_lock>
    8000163c:	2ec040ef          	jal	80005928 <release>
}
    80001640:	854e                	mv	a0,s3
    80001642:	60a6                	ld	ra,72(sp)
    80001644:	6406                	ld	s0,64(sp)
    80001646:	74e2                	ld	s1,56(sp)
    80001648:	7942                	ld	s2,48(sp)
    8000164a:	79a2                	ld	s3,40(sp)
    8000164c:	7a02                	ld	s4,32(sp)
    8000164e:	6ae2                	ld	s5,24(sp)
    80001650:	6b42                	ld	s6,16(sp)
    80001652:	6ba2                	ld	s7,8(sp)
    80001654:	6c02                	ld	s8,0(sp)
    80001656:	6161                	addi	sp,sp,80
    80001658:	8082                	ret
            release(&pp->lock);
    8000165a:	8526                	mv	a0,s1
    8000165c:	2cc040ef          	jal	80005928 <release>
            release(&wait_lock);
    80001660:	00009517          	auipc	a0,0x9
    80001664:	e5850513          	addi	a0,a0,-424 # 8000a4b8 <wait_lock>
    80001668:	2c0040ef          	jal	80005928 <release>
            return -1;
    8000166c:	59fd                	li	s3,-1
    8000166e:	bfc9                	j	80001640 <wait+0x78>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001670:	16848493          	addi	s1,s1,360
    80001674:	03348063          	beq	s1,s3,80001694 <wait+0xcc>
      if(pp->parent == p){
    80001678:	7c9c                	ld	a5,56(s1)
    8000167a:	ff279be3          	bne	a5,s2,80001670 <wait+0xa8>
        acquire(&pp->lock);
    8000167e:	8526                	mv	a0,s1
    80001680:	210040ef          	jal	80005890 <acquire>
        if(pp->state == ZOMBIE){
    80001684:	4c9c                	lw	a5,24(s1)
    80001686:	f94783e3          	beq	a5,s4,8000160c <wait+0x44>
        release(&pp->lock);
    8000168a:	8526                	mv	a0,s1
    8000168c:	29c040ef          	jal	80005928 <release>
        havekids = 1;
    80001690:	8756                	mv	a4,s5
    80001692:	bff9                	j	80001670 <wait+0xa8>
    if(!havekids || killed(p)){
    80001694:	cf19                	beqz	a4,800016b2 <wait+0xea>
    80001696:	854a                	mv	a0,s2
    80001698:	f07ff0ef          	jal	8000159e <killed>
    8000169c:	e919                	bnez	a0,800016b2 <wait+0xea>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000169e:	85e2                	mv	a1,s8
    800016a0:	854a                	mv	a0,s2
    800016a2:	cc5ff0ef          	jal	80001366 <sleep>
    havekids = 0;
    800016a6:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800016a8:	00009497          	auipc	s1,0x9
    800016ac:	22848493          	addi	s1,s1,552 # 8000a8d0 <proc>
    800016b0:	b7e1                	j	80001678 <wait+0xb0>
      release(&wait_lock);
    800016b2:	00009517          	auipc	a0,0x9
    800016b6:	e0650513          	addi	a0,a0,-506 # 8000a4b8 <wait_lock>
    800016ba:	26e040ef          	jal	80005928 <release>
      return -1;
    800016be:	59fd                	li	s3,-1
    800016c0:	b741                	j	80001640 <wait+0x78>

00000000800016c2 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800016c2:	7179                	addi	sp,sp,-48
    800016c4:	f406                	sd	ra,40(sp)
    800016c6:	f022                	sd	s0,32(sp)
    800016c8:	ec26                	sd	s1,24(sp)
    800016ca:	e84a                	sd	s2,16(sp)
    800016cc:	e44e                	sd	s3,8(sp)
    800016ce:	e052                	sd	s4,0(sp)
    800016d0:	1800                	addi	s0,sp,48
    800016d2:	84aa                	mv	s1,a0
    800016d4:	892e                	mv	s2,a1
    800016d6:	89b2                	mv	s3,a2
    800016d8:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800016da:	ebeff0ef          	jal	80000d98 <myproc>
  if(user_dst){
    800016de:	cc99                	beqz	s1,800016fc <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    800016e0:	86d2                	mv	a3,s4
    800016e2:	864e                	mv	a2,s3
    800016e4:	85ca                	mv	a1,s2
    800016e6:	6928                	ld	a0,80(a0)
    800016e8:	b20ff0ef          	jal	80000a08 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800016ec:	70a2                	ld	ra,40(sp)
    800016ee:	7402                	ld	s0,32(sp)
    800016f0:	64e2                	ld	s1,24(sp)
    800016f2:	6942                	ld	s2,16(sp)
    800016f4:	69a2                	ld	s3,8(sp)
    800016f6:	6a02                	ld	s4,0(sp)
    800016f8:	6145                	addi	sp,sp,48
    800016fa:	8082                	ret
    memmove((char *)dst, src, len);
    800016fc:	000a061b          	sext.w	a2,s4
    80001700:	85ce                	mv	a1,s3
    80001702:	854a                	mv	a0,s2
    80001704:	acffe0ef          	jal	800001d2 <memmove>
    return 0;
    80001708:	8526                	mv	a0,s1
    8000170a:	b7cd                	j	800016ec <either_copyout+0x2a>

000000008000170c <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000170c:	7179                	addi	sp,sp,-48
    8000170e:	f406                	sd	ra,40(sp)
    80001710:	f022                	sd	s0,32(sp)
    80001712:	ec26                	sd	s1,24(sp)
    80001714:	e84a                	sd	s2,16(sp)
    80001716:	e44e                	sd	s3,8(sp)
    80001718:	e052                	sd	s4,0(sp)
    8000171a:	1800                	addi	s0,sp,48
    8000171c:	892a                	mv	s2,a0
    8000171e:	84ae                	mv	s1,a1
    80001720:	89b2                	mv	s3,a2
    80001722:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001724:	e74ff0ef          	jal	80000d98 <myproc>
  if(user_src){
    80001728:	cc99                	beqz	s1,80001746 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    8000172a:	86d2                	mv	a3,s4
    8000172c:	864e                	mv	a2,s3
    8000172e:	85ca                	mv	a1,s2
    80001730:	6928                	ld	a0,80(a0)
    80001732:	baeff0ef          	jal	80000ae0 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001736:	70a2                	ld	ra,40(sp)
    80001738:	7402                	ld	s0,32(sp)
    8000173a:	64e2                	ld	s1,24(sp)
    8000173c:	6942                	ld	s2,16(sp)
    8000173e:	69a2                	ld	s3,8(sp)
    80001740:	6a02                	ld	s4,0(sp)
    80001742:	6145                	addi	sp,sp,48
    80001744:	8082                	ret
    memmove(dst, (char*)src, len);
    80001746:	000a061b          	sext.w	a2,s4
    8000174a:	85ce                	mv	a1,s3
    8000174c:	854a                	mv	a0,s2
    8000174e:	a85fe0ef          	jal	800001d2 <memmove>
    return 0;
    80001752:	8526                	mv	a0,s1
    80001754:	b7cd                	j	80001736 <either_copyin+0x2a>

0000000080001756 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001756:	715d                	addi	sp,sp,-80
    80001758:	e486                	sd	ra,72(sp)
    8000175a:	e0a2                	sd	s0,64(sp)
    8000175c:	fc26                	sd	s1,56(sp)
    8000175e:	f84a                	sd	s2,48(sp)
    80001760:	f44e                	sd	s3,40(sp)
    80001762:	f052                	sd	s4,32(sp)
    80001764:	ec56                	sd	s5,24(sp)
    80001766:	e85a                	sd	s6,16(sp)
    80001768:	e45e                	sd	s7,8(sp)
    8000176a:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000176c:	00006517          	auipc	a0,0x6
    80001770:	8cc50513          	addi	a0,a0,-1844 # 80007038 <etext+0x38>
    80001774:	31d030ef          	jal	80005290 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001778:	00009497          	auipc	s1,0x9
    8000177c:	2b048493          	addi	s1,s1,688 # 8000aa28 <proc+0x158>
    80001780:	0000f917          	auipc	s2,0xf
    80001784:	ca890913          	addi	s2,s2,-856 # 80010428 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001788:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    8000178a:	00006997          	auipc	s3,0x6
    8000178e:	ab698993          	addi	s3,s3,-1354 # 80007240 <etext+0x240>
    printf("%d %s %s", p->pid, state, p->name);
    80001792:	00006a97          	auipc	s5,0x6
    80001796:	ab6a8a93          	addi	s5,s5,-1354 # 80007248 <etext+0x248>
    printf("\n");
    8000179a:	00006a17          	auipc	s4,0x6
    8000179e:	89ea0a13          	addi	s4,s4,-1890 # 80007038 <etext+0x38>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800017a2:	00006b97          	auipc	s7,0x6
    800017a6:	08eb8b93          	addi	s7,s7,142 # 80007830 <states.0>
    800017aa:	a829                	j	800017c4 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    800017ac:	ed86a583          	lw	a1,-296(a3)
    800017b0:	8556                	mv	a0,s5
    800017b2:	2df030ef          	jal	80005290 <printf>
    printf("\n");
    800017b6:	8552                	mv	a0,s4
    800017b8:	2d9030ef          	jal	80005290 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800017bc:	16848493          	addi	s1,s1,360
    800017c0:	03248263          	beq	s1,s2,800017e4 <procdump+0x8e>
    if(p->state == UNUSED)
    800017c4:	86a6                	mv	a3,s1
    800017c6:	ec04a783          	lw	a5,-320(s1)
    800017ca:	dbed                	beqz	a5,800017bc <procdump+0x66>
      state = "???";
    800017cc:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800017ce:	fcfb6fe3          	bltu	s6,a5,800017ac <procdump+0x56>
    800017d2:	02079713          	slli	a4,a5,0x20
    800017d6:	01d75793          	srli	a5,a4,0x1d
    800017da:	97de                	add	a5,a5,s7
    800017dc:	6390                	ld	a2,0(a5)
    800017de:	f679                	bnez	a2,800017ac <procdump+0x56>
      state = "???";
    800017e0:	864e                	mv	a2,s3
    800017e2:	b7e9                	j	800017ac <procdump+0x56>
  }
}
    800017e4:	60a6                	ld	ra,72(sp)
    800017e6:	6406                	ld	s0,64(sp)
    800017e8:	74e2                	ld	s1,56(sp)
    800017ea:	7942                	ld	s2,48(sp)
    800017ec:	79a2                	ld	s3,40(sp)
    800017ee:	7a02                	ld	s4,32(sp)
    800017f0:	6ae2                	ld	s5,24(sp)
    800017f2:	6b42                	ld	s6,16(sp)
    800017f4:	6ba2                	ld	s7,8(sp)
    800017f6:	6161                	addi	sp,sp,80
    800017f8:	8082                	ret

00000000800017fa <nproc_count>:

uint64
nproc_count(void)
{
    800017fa:	7179                	addi	sp,sp,-48
    800017fc:	f406                	sd	ra,40(sp)
    800017fe:	f022                	sd	s0,32(sp)
    80001800:	ec26                	sd	s1,24(sp)
    80001802:	e84a                	sd	s2,16(sp)
    80001804:	e44e                	sd	s3,8(sp)
    80001806:	1800                	addi	s0,sp,48
  struct proc *p;
  uint64 count = 0;
    80001808:	4901                	li	s2,0

  for(p = proc; p < &proc[NPROC]; p++){
    8000180a:	00009497          	auipc	s1,0x9
    8000180e:	0c648493          	addi	s1,s1,198 # 8000a8d0 <proc>
    80001812:	0000f997          	auipc	s3,0xf
    80001816:	abe98993          	addi	s3,s3,-1346 # 800102d0 <tickslock>
    acquire(&p->lock);
    8000181a:	8526                	mv	a0,s1
    8000181c:	074040ef          	jal	80005890 <acquire>

    if(p->state != UNUSED)
    80001820:	4c9c                	lw	a5,24(s1)
      count++;
    80001822:	00f037b3          	snez	a5,a5
    80001826:	993e                	add	s2,s2,a5

    release(&p->lock);
    80001828:	8526                	mv	a0,s1
    8000182a:	0fe040ef          	jal	80005928 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000182e:	16848493          	addi	s1,s1,360
    80001832:	ff3494e3          	bne	s1,s3,8000181a <nproc_count+0x20>
  }
  return count;
}
    80001836:	854a                	mv	a0,s2
    80001838:	70a2                	ld	ra,40(sp)
    8000183a:	7402                	ld	s0,32(sp)
    8000183c:	64e2                	ld	s1,24(sp)
    8000183e:	6942                	ld	s2,16(sp)
    80001840:	69a2                	ld	s3,8(sp)
    80001842:	6145                	addi	sp,sp,48
    80001844:	8082                	ret

0000000080001846 <swtch>:
    80001846:	00153023          	sd	ra,0(a0)
    8000184a:	00253423          	sd	sp,8(a0)
    8000184e:	e900                	sd	s0,16(a0)
    80001850:	ed04                	sd	s1,24(a0)
    80001852:	03253023          	sd	s2,32(a0)
    80001856:	03353423          	sd	s3,40(a0)
    8000185a:	03453823          	sd	s4,48(a0)
    8000185e:	03553c23          	sd	s5,56(a0)
    80001862:	05653023          	sd	s6,64(a0)
    80001866:	05753423          	sd	s7,72(a0)
    8000186a:	05853823          	sd	s8,80(a0)
    8000186e:	05953c23          	sd	s9,88(a0)
    80001872:	07a53023          	sd	s10,96(a0)
    80001876:	07b53423          	sd	s11,104(a0)
    8000187a:	0005b083          	ld	ra,0(a1)
    8000187e:	0085b103          	ld	sp,8(a1)
    80001882:	6980                	ld	s0,16(a1)
    80001884:	6d84                	ld	s1,24(a1)
    80001886:	0205b903          	ld	s2,32(a1)
    8000188a:	0285b983          	ld	s3,40(a1)
    8000188e:	0305ba03          	ld	s4,48(a1)
    80001892:	0385ba83          	ld	s5,56(a1)
    80001896:	0405bb03          	ld	s6,64(a1)
    8000189a:	0485bb83          	ld	s7,72(a1)
    8000189e:	0505bc03          	ld	s8,80(a1)
    800018a2:	0585bc83          	ld	s9,88(a1)
    800018a6:	0605bd03          	ld	s10,96(a1)
    800018aa:	0685bd83          	ld	s11,104(a1)
    800018ae:	8082                	ret

00000000800018b0 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800018b0:	1141                	addi	sp,sp,-16
    800018b2:	e406                	sd	ra,8(sp)
    800018b4:	e022                	sd	s0,0(sp)
    800018b6:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800018b8:	00006597          	auipc	a1,0x6
    800018bc:	9d058593          	addi	a1,a1,-1584 # 80007288 <etext+0x288>
    800018c0:	0000f517          	auipc	a0,0xf
    800018c4:	a1050513          	addi	a0,a0,-1520 # 800102d0 <tickslock>
    800018c8:	749030ef          	jal	80005810 <initlock>
}
    800018cc:	60a2                	ld	ra,8(sp)
    800018ce:	6402                	ld	s0,0(sp)
    800018d0:	0141                	addi	sp,sp,16
    800018d2:	8082                	ret

00000000800018d4 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800018d4:	1141                	addi	sp,sp,-16
    800018d6:	e422                	sd	s0,8(sp)
    800018d8:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800018da:	00003797          	auipc	a5,0x3
    800018de:	ef678793          	addi	a5,a5,-266 # 800047d0 <kernelvec>
    800018e2:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800018e6:	6422                	ld	s0,8(sp)
    800018e8:	0141                	addi	sp,sp,16
    800018ea:	8082                	ret

00000000800018ec <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    800018ec:	1141                	addi	sp,sp,-16
    800018ee:	e406                	sd	ra,8(sp)
    800018f0:	e022                	sd	s0,0(sp)
    800018f2:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800018f4:	ca4ff0ef          	jal	80000d98 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800018f8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800018fc:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800018fe:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001902:	00004697          	auipc	a3,0x4
    80001906:	6fe68693          	addi	a3,a3,1790 # 80006000 <_trampoline>
    8000190a:	00004717          	auipc	a4,0x4
    8000190e:	6f670713          	addi	a4,a4,1782 # 80006000 <_trampoline>
    80001912:	8f15                	sub	a4,a4,a3
    80001914:	040007b7          	lui	a5,0x4000
    80001918:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    8000191a:	07b2                	slli	a5,a5,0xc
    8000191c:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000191e:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001922:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001924:	18002673          	csrr	a2,satp
    80001928:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    8000192a:	6d30                	ld	a2,88(a0)
    8000192c:	6138                	ld	a4,64(a0)
    8000192e:	6585                	lui	a1,0x1
    80001930:	972e                	add	a4,a4,a1
    80001932:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001934:	6d38                	ld	a4,88(a0)
    80001936:	00000617          	auipc	a2,0x0
    8000193a:	11060613          	addi	a2,a2,272 # 80001a46 <usertrap>
    8000193e:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001940:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001942:	8612                	mv	a2,tp
    80001944:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001946:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    8000194a:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    8000194e:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001952:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001956:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001958:	6f18                	ld	a4,24(a4)
    8000195a:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    8000195e:	6928                	ld	a0,80(a0)
    80001960:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001962:	00004717          	auipc	a4,0x4
    80001966:	73a70713          	addi	a4,a4,1850 # 8000609c <userret>
    8000196a:	8f15                	sub	a4,a4,a3
    8000196c:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    8000196e:	577d                	li	a4,-1
    80001970:	177e                	slli	a4,a4,0x3f
    80001972:	8d59                	or	a0,a0,a4
    80001974:	9782                	jalr	a5
}
    80001976:	60a2                	ld	ra,8(sp)
    80001978:	6402                	ld	s0,0(sp)
    8000197a:	0141                	addi	sp,sp,16
    8000197c:	8082                	ret

000000008000197e <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    8000197e:	1101                	addi	sp,sp,-32
    80001980:	ec06                	sd	ra,24(sp)
    80001982:	e822                	sd	s0,16(sp)
    80001984:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    80001986:	be6ff0ef          	jal	80000d6c <cpuid>
    8000198a:	cd11                	beqz	a0,800019a6 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    8000198c:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80001990:	000f4737          	lui	a4,0xf4
    80001994:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80001998:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    8000199a:	14d79073          	csrw	stimecmp,a5
}
    8000199e:	60e2                	ld	ra,24(sp)
    800019a0:	6442                	ld	s0,16(sp)
    800019a2:	6105                	addi	sp,sp,32
    800019a4:	8082                	ret
    800019a6:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    800019a8:	0000f497          	auipc	s1,0xf
    800019ac:	92848493          	addi	s1,s1,-1752 # 800102d0 <tickslock>
    800019b0:	8526                	mv	a0,s1
    800019b2:	6df030ef          	jal	80005890 <acquire>
    ticks++;
    800019b6:	00009517          	auipc	a0,0x9
    800019ba:	ab250513          	addi	a0,a0,-1358 # 8000a468 <ticks>
    800019be:	411c                	lw	a5,0(a0)
    800019c0:	2785                	addiw	a5,a5,1
    800019c2:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    800019c4:	9efff0ef          	jal	800013b2 <wakeup>
    release(&tickslock);
    800019c8:	8526                	mv	a0,s1
    800019ca:	75f030ef          	jal	80005928 <release>
    800019ce:	64a2                	ld	s1,8(sp)
    800019d0:	bf75                	j	8000198c <clockintr+0xe>

00000000800019d2 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    800019d2:	1101                	addi	sp,sp,-32
    800019d4:	ec06                	sd	ra,24(sp)
    800019d6:	e822                	sd	s0,16(sp)
    800019d8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800019da:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    800019de:	57fd                	li	a5,-1
    800019e0:	17fe                	slli	a5,a5,0x3f
    800019e2:	07a5                	addi	a5,a5,9
    800019e4:	00f70c63          	beq	a4,a5,800019fc <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    800019e8:	57fd                	li	a5,-1
    800019ea:	17fe                	slli	a5,a5,0x3f
    800019ec:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    800019ee:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    800019f0:	04f70763          	beq	a4,a5,80001a3e <devintr+0x6c>
  }
}
    800019f4:	60e2                	ld	ra,24(sp)
    800019f6:	6442                	ld	s0,16(sp)
    800019f8:	6105                	addi	sp,sp,32
    800019fa:	8082                	ret
    800019fc:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    800019fe:	67f020ef          	jal	8000487c <plic_claim>
    80001a02:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001a04:	47a9                	li	a5,10
    80001a06:	00f50963          	beq	a0,a5,80001a18 <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    80001a0a:	4785                	li	a5,1
    80001a0c:	00f50963          	beq	a0,a5,80001a1e <devintr+0x4c>
    return 1;
    80001a10:	4505                	li	a0,1
    } else if(irq){
    80001a12:	e889                	bnez	s1,80001a24 <devintr+0x52>
    80001a14:	64a2                	ld	s1,8(sp)
    80001a16:	bff9                	j	800019f4 <devintr+0x22>
      uartintr();
    80001a18:	5bd030ef          	jal	800057d4 <uartintr>
    if(irq)
    80001a1c:	a819                	j	80001a32 <devintr+0x60>
      virtio_disk_intr();
    80001a1e:	324030ef          	jal	80004d42 <virtio_disk_intr>
    if(irq)
    80001a22:	a801                	j	80001a32 <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    80001a24:	85a6                	mv	a1,s1
    80001a26:	00006517          	auipc	a0,0x6
    80001a2a:	86a50513          	addi	a0,a0,-1942 # 80007290 <etext+0x290>
    80001a2e:	063030ef          	jal	80005290 <printf>
      plic_complete(irq);
    80001a32:	8526                	mv	a0,s1
    80001a34:	669020ef          	jal	8000489c <plic_complete>
    return 1;
    80001a38:	4505                	li	a0,1
    80001a3a:	64a2                	ld	s1,8(sp)
    80001a3c:	bf65                	j	800019f4 <devintr+0x22>
    clockintr();
    80001a3e:	f41ff0ef          	jal	8000197e <clockintr>
    return 2;
    80001a42:	4509                	li	a0,2
    80001a44:	bf45                	j	800019f4 <devintr+0x22>

0000000080001a46 <usertrap>:
{
    80001a46:	1101                	addi	sp,sp,-32
    80001a48:	ec06                	sd	ra,24(sp)
    80001a4a:	e822                	sd	s0,16(sp)
    80001a4c:	e426                	sd	s1,8(sp)
    80001a4e:	e04a                	sd	s2,0(sp)
    80001a50:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001a52:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001a56:	1007f793          	andi	a5,a5,256
    80001a5a:	ef85                	bnez	a5,80001a92 <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001a5c:	00003797          	auipc	a5,0x3
    80001a60:	d7478793          	addi	a5,a5,-652 # 800047d0 <kernelvec>
    80001a64:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001a68:	b30ff0ef          	jal	80000d98 <myproc>
    80001a6c:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001a6e:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001a70:	14102773          	csrr	a4,sepc
    80001a74:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001a76:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001a7a:	47a1                	li	a5,8
    80001a7c:	02f70163          	beq	a4,a5,80001a9e <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    80001a80:	f53ff0ef          	jal	800019d2 <devintr>
    80001a84:	892a                	mv	s2,a0
    80001a86:	c135                	beqz	a0,80001aea <usertrap+0xa4>
  if(killed(p))
    80001a88:	8526                	mv	a0,s1
    80001a8a:	b15ff0ef          	jal	8000159e <killed>
    80001a8e:	cd1d                	beqz	a0,80001acc <usertrap+0x86>
    80001a90:	a81d                	j	80001ac6 <usertrap+0x80>
    panic("usertrap: not from user mode");
    80001a92:	00006517          	auipc	a0,0x6
    80001a96:	81e50513          	addi	a0,a0,-2018 # 800072b0 <etext+0x2b0>
    80001a9a:	2c9030ef          	jal	80005562 <panic>
    if(killed(p))
    80001a9e:	b01ff0ef          	jal	8000159e <killed>
    80001aa2:	e121                	bnez	a0,80001ae2 <usertrap+0x9c>
    p->trapframe->epc += 4;
    80001aa4:	6cb8                	ld	a4,88(s1)
    80001aa6:	6f1c                	ld	a5,24(a4)
    80001aa8:	0791                	addi	a5,a5,4
    80001aaa:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001aac:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001ab0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ab4:	10079073          	csrw	sstatus,a5
    syscall();
    80001ab8:	248000ef          	jal	80001d00 <syscall>
  if(killed(p))
    80001abc:	8526                	mv	a0,s1
    80001abe:	ae1ff0ef          	jal	8000159e <killed>
    80001ac2:	c901                	beqz	a0,80001ad2 <usertrap+0x8c>
    80001ac4:	4901                	li	s2,0
    exit(-1);
    80001ac6:	557d                	li	a0,-1
    80001ac8:	9abff0ef          	jal	80001472 <exit>
  if(which_dev == 2)
    80001acc:	4789                	li	a5,2
    80001ace:	04f90563          	beq	s2,a5,80001b18 <usertrap+0xd2>
  usertrapret();
    80001ad2:	e1bff0ef          	jal	800018ec <usertrapret>
}
    80001ad6:	60e2                	ld	ra,24(sp)
    80001ad8:	6442                	ld	s0,16(sp)
    80001ada:	64a2                	ld	s1,8(sp)
    80001adc:	6902                	ld	s2,0(sp)
    80001ade:	6105                	addi	sp,sp,32
    80001ae0:	8082                	ret
      exit(-1);
    80001ae2:	557d                	li	a0,-1
    80001ae4:	98fff0ef          	jal	80001472 <exit>
    80001ae8:	bf75                	j	80001aa4 <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001aea:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80001aee:	5890                	lw	a2,48(s1)
    80001af0:	00005517          	auipc	a0,0x5
    80001af4:	7e050513          	addi	a0,a0,2016 # 800072d0 <etext+0x2d0>
    80001af8:	798030ef          	jal	80005290 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001afc:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001b00:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001b04:	00005517          	auipc	a0,0x5
    80001b08:	7fc50513          	addi	a0,a0,2044 # 80007300 <etext+0x300>
    80001b0c:	784030ef          	jal	80005290 <printf>
    setkilled(p);
    80001b10:	8526                	mv	a0,s1
    80001b12:	a69ff0ef          	jal	8000157a <setkilled>
    80001b16:	b75d                	j	80001abc <usertrap+0x76>
    yield();
    80001b18:	823ff0ef          	jal	8000133a <yield>
    80001b1c:	bf5d                	j	80001ad2 <usertrap+0x8c>

0000000080001b1e <kerneltrap>:
{
    80001b1e:	7179                	addi	sp,sp,-48
    80001b20:	f406                	sd	ra,40(sp)
    80001b22:	f022                	sd	s0,32(sp)
    80001b24:	ec26                	sd	s1,24(sp)
    80001b26:	e84a                	sd	s2,16(sp)
    80001b28:	e44e                	sd	s3,8(sp)
    80001b2a:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b2c:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b30:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001b34:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001b38:	1004f793          	andi	a5,s1,256
    80001b3c:	c795                	beqz	a5,80001b68 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b3e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001b42:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001b44:	eb85                	bnez	a5,80001b74 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80001b46:	e8dff0ef          	jal	800019d2 <devintr>
    80001b4a:	c91d                	beqz	a0,80001b80 <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80001b4c:	4789                	li	a5,2
    80001b4e:	04f50a63          	beq	a0,a5,80001ba2 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b52:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b56:	10049073          	csrw	sstatus,s1
}
    80001b5a:	70a2                	ld	ra,40(sp)
    80001b5c:	7402                	ld	s0,32(sp)
    80001b5e:	64e2                	ld	s1,24(sp)
    80001b60:	6942                	ld	s2,16(sp)
    80001b62:	69a2                	ld	s3,8(sp)
    80001b64:	6145                	addi	sp,sp,48
    80001b66:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001b68:	00005517          	auipc	a0,0x5
    80001b6c:	7c050513          	addi	a0,a0,1984 # 80007328 <etext+0x328>
    80001b70:	1f3030ef          	jal	80005562 <panic>
    panic("kerneltrap: interrupts enabled");
    80001b74:	00005517          	auipc	a0,0x5
    80001b78:	7dc50513          	addi	a0,a0,2012 # 80007350 <etext+0x350>
    80001b7c:	1e7030ef          	jal	80005562 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b80:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001b84:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001b88:	85ce                	mv	a1,s3
    80001b8a:	00005517          	auipc	a0,0x5
    80001b8e:	7e650513          	addi	a0,a0,2022 # 80007370 <etext+0x370>
    80001b92:	6fe030ef          	jal	80005290 <printf>
    panic("kerneltrap");
    80001b96:	00006517          	auipc	a0,0x6
    80001b9a:	80250513          	addi	a0,a0,-2046 # 80007398 <etext+0x398>
    80001b9e:	1c5030ef          	jal	80005562 <panic>
  if(which_dev == 2 && myproc() != 0)
    80001ba2:	9f6ff0ef          	jal	80000d98 <myproc>
    80001ba6:	d555                	beqz	a0,80001b52 <kerneltrap+0x34>
    yield();
    80001ba8:	f92ff0ef          	jal	8000133a <yield>
    80001bac:	b75d                	j	80001b52 <kerneltrap+0x34>

0000000080001bae <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001bae:	1101                	addi	sp,sp,-32
    80001bb0:	ec06                	sd	ra,24(sp)
    80001bb2:	e822                	sd	s0,16(sp)
    80001bb4:	e426                	sd	s1,8(sp)
    80001bb6:	1000                	addi	s0,sp,32
    80001bb8:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001bba:	9deff0ef          	jal	80000d98 <myproc>
  switch (n) {
    80001bbe:	4795                	li	a5,5
    80001bc0:	0497e163          	bltu	a5,s1,80001c02 <argraw+0x54>
    80001bc4:	048a                	slli	s1,s1,0x2
    80001bc6:	00006717          	auipc	a4,0x6
    80001bca:	c9a70713          	addi	a4,a4,-870 # 80007860 <states.0+0x30>
    80001bce:	94ba                	add	s1,s1,a4
    80001bd0:	409c                	lw	a5,0(s1)
    80001bd2:	97ba                	add	a5,a5,a4
    80001bd4:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001bd6:	6d3c                	ld	a5,88(a0)
    80001bd8:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001bda:	60e2                	ld	ra,24(sp)
    80001bdc:	6442                	ld	s0,16(sp)
    80001bde:	64a2                	ld	s1,8(sp)
    80001be0:	6105                	addi	sp,sp,32
    80001be2:	8082                	ret
    return p->trapframe->a1;
    80001be4:	6d3c                	ld	a5,88(a0)
    80001be6:	7fa8                	ld	a0,120(a5)
    80001be8:	bfcd                	j	80001bda <argraw+0x2c>
    return p->trapframe->a2;
    80001bea:	6d3c                	ld	a5,88(a0)
    80001bec:	63c8                	ld	a0,128(a5)
    80001bee:	b7f5                	j	80001bda <argraw+0x2c>
    return p->trapframe->a3;
    80001bf0:	6d3c                	ld	a5,88(a0)
    80001bf2:	67c8                	ld	a0,136(a5)
    80001bf4:	b7dd                	j	80001bda <argraw+0x2c>
    return p->trapframe->a4;
    80001bf6:	6d3c                	ld	a5,88(a0)
    80001bf8:	6bc8                	ld	a0,144(a5)
    80001bfa:	b7c5                	j	80001bda <argraw+0x2c>
    return p->trapframe->a5;
    80001bfc:	6d3c                	ld	a5,88(a0)
    80001bfe:	6fc8                	ld	a0,152(a5)
    80001c00:	bfe9                	j	80001bda <argraw+0x2c>
  panic("argraw");
    80001c02:	00005517          	auipc	a0,0x5
    80001c06:	7a650513          	addi	a0,a0,1958 # 800073a8 <etext+0x3a8>
    80001c0a:	159030ef          	jal	80005562 <panic>

0000000080001c0e <fetchaddr>:
{
    80001c0e:	1101                	addi	sp,sp,-32
    80001c10:	ec06                	sd	ra,24(sp)
    80001c12:	e822                	sd	s0,16(sp)
    80001c14:	e426                	sd	s1,8(sp)
    80001c16:	e04a                	sd	s2,0(sp)
    80001c18:	1000                	addi	s0,sp,32
    80001c1a:	84aa                	mv	s1,a0
    80001c1c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001c1e:	97aff0ef          	jal	80000d98 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001c22:	653c                	ld	a5,72(a0)
    80001c24:	02f4f663          	bgeu	s1,a5,80001c50 <fetchaddr+0x42>
    80001c28:	00848713          	addi	a4,s1,8
    80001c2c:	02e7e463          	bltu	a5,a4,80001c54 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001c30:	46a1                	li	a3,8
    80001c32:	8626                	mv	a2,s1
    80001c34:	85ca                	mv	a1,s2
    80001c36:	6928                	ld	a0,80(a0)
    80001c38:	ea9fe0ef          	jal	80000ae0 <copyin>
    80001c3c:	00a03533          	snez	a0,a0
    80001c40:	40a00533          	neg	a0,a0
}
    80001c44:	60e2                	ld	ra,24(sp)
    80001c46:	6442                	ld	s0,16(sp)
    80001c48:	64a2                	ld	s1,8(sp)
    80001c4a:	6902                	ld	s2,0(sp)
    80001c4c:	6105                	addi	sp,sp,32
    80001c4e:	8082                	ret
    return -1;
    80001c50:	557d                	li	a0,-1
    80001c52:	bfcd                	j	80001c44 <fetchaddr+0x36>
    80001c54:	557d                	li	a0,-1
    80001c56:	b7fd                	j	80001c44 <fetchaddr+0x36>

0000000080001c58 <fetchstr>:
{
    80001c58:	7179                	addi	sp,sp,-48
    80001c5a:	f406                	sd	ra,40(sp)
    80001c5c:	f022                	sd	s0,32(sp)
    80001c5e:	ec26                	sd	s1,24(sp)
    80001c60:	e84a                	sd	s2,16(sp)
    80001c62:	e44e                	sd	s3,8(sp)
    80001c64:	1800                	addi	s0,sp,48
    80001c66:	892a                	mv	s2,a0
    80001c68:	84ae                	mv	s1,a1
    80001c6a:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001c6c:	92cff0ef          	jal	80000d98 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001c70:	86ce                	mv	a3,s3
    80001c72:	864a                	mv	a2,s2
    80001c74:	85a6                	mv	a1,s1
    80001c76:	6928                	ld	a0,80(a0)
    80001c78:	eeffe0ef          	jal	80000b66 <copyinstr>
    80001c7c:	00054c63          	bltz	a0,80001c94 <fetchstr+0x3c>
  return strlen(buf);
    80001c80:	8526                	mv	a0,s1
    80001c82:	e64fe0ef          	jal	800002e6 <strlen>
}
    80001c86:	70a2                	ld	ra,40(sp)
    80001c88:	7402                	ld	s0,32(sp)
    80001c8a:	64e2                	ld	s1,24(sp)
    80001c8c:	6942                	ld	s2,16(sp)
    80001c8e:	69a2                	ld	s3,8(sp)
    80001c90:	6145                	addi	sp,sp,48
    80001c92:	8082                	ret
    return -1;
    80001c94:	557d                	li	a0,-1
    80001c96:	bfc5                	j	80001c86 <fetchstr+0x2e>

0000000080001c98 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001c98:	1101                	addi	sp,sp,-32
    80001c9a:	ec06                	sd	ra,24(sp)
    80001c9c:	e822                	sd	s0,16(sp)
    80001c9e:	e426                	sd	s1,8(sp)
    80001ca0:	1000                	addi	s0,sp,32
    80001ca2:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001ca4:	f0bff0ef          	jal	80001bae <argraw>
    80001ca8:	c088                	sw	a0,0(s1)
}
    80001caa:	60e2                	ld	ra,24(sp)
    80001cac:	6442                	ld	s0,16(sp)
    80001cae:	64a2                	ld	s1,8(sp)
    80001cb0:	6105                	addi	sp,sp,32
    80001cb2:	8082                	ret

0000000080001cb4 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001cb4:	1101                	addi	sp,sp,-32
    80001cb6:	ec06                	sd	ra,24(sp)
    80001cb8:	e822                	sd	s0,16(sp)
    80001cba:	e426                	sd	s1,8(sp)
    80001cbc:	1000                	addi	s0,sp,32
    80001cbe:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001cc0:	eefff0ef          	jal	80001bae <argraw>
    80001cc4:	e088                	sd	a0,0(s1)
}
    80001cc6:	60e2                	ld	ra,24(sp)
    80001cc8:	6442                	ld	s0,16(sp)
    80001cca:	64a2                	ld	s1,8(sp)
    80001ccc:	6105                	addi	sp,sp,32
    80001cce:	8082                	ret

0000000080001cd0 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001cd0:	7179                	addi	sp,sp,-48
    80001cd2:	f406                	sd	ra,40(sp)
    80001cd4:	f022                	sd	s0,32(sp)
    80001cd6:	ec26                	sd	s1,24(sp)
    80001cd8:	e84a                	sd	s2,16(sp)
    80001cda:	1800                	addi	s0,sp,48
    80001cdc:	84ae                	mv	s1,a1
    80001cde:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80001ce0:	fd840593          	addi	a1,s0,-40
    80001ce4:	fd1ff0ef          	jal	80001cb4 <argaddr>
  return fetchstr(addr, buf, max);
    80001ce8:	864a                	mv	a2,s2
    80001cea:	85a6                	mv	a1,s1
    80001cec:	fd843503          	ld	a0,-40(s0)
    80001cf0:	f69ff0ef          	jal	80001c58 <fetchstr>
}
    80001cf4:	70a2                	ld	ra,40(sp)
    80001cf6:	7402                	ld	s0,32(sp)
    80001cf8:	64e2                	ld	s1,24(sp)
    80001cfa:	6942                	ld	s2,16(sp)
    80001cfc:	6145                	addi	sp,sp,48
    80001cfe:	8082                	ret

0000000080001d00 <syscall>:
  "trace",   // 22
  "sysinfo", // 23
};

void syscall(void)
{
    80001d00:	7179                	addi	sp,sp,-48
    80001d02:	f406                	sd	ra,40(sp)
    80001d04:	f022                	sd	s0,32(sp)
    80001d06:	ec26                	sd	s1,24(sp)
    80001d08:	e84a                	sd	s2,16(sp)
    80001d0a:	e44e                	sd	s3,8(sp)
    80001d0c:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    80001d0e:	88aff0ef          	jal	80000d98 <myproc>
    80001d12:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001d14:	05853903          	ld	s2,88(a0)
    80001d18:	0a893783          	ld	a5,168(s2)
    80001d1c:	0007899b          	sext.w	s3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001d20:	37fd                	addiw	a5,a5,-1
    80001d22:	4759                	li	a4,22
    80001d24:	04f76463          	bltu	a4,a5,80001d6c <syscall+0x6c>
    80001d28:	00399713          	slli	a4,s3,0x3
    80001d2c:	00006797          	auipc	a5,0x6
    80001d30:	b4c78793          	addi	a5,a5,-1204 # 80007878 <syscalls>
    80001d34:	97ba                	add	a5,a5,a4
    80001d36:	639c                	ld	a5,0(a5)
    80001d38:	cb95                	beqz	a5,80001d6c <syscall+0x6c>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80001d3a:	9782                	jalr	a5
    80001d3c:	06a93823          	sd	a0,112(s2)

    if (p -> tracemask & (1 << num))
    80001d40:	58dc                	lw	a5,52(s1)
    80001d42:	4137d7bb          	sraw	a5,a5,s3
    80001d46:	8b85                	andi	a5,a5,1
    80001d48:	cf9d                	beqz	a5,80001d86 <syscall+0x86>
    {
      printf("%d: syscall %s -> %ld\n", p -> pid, syscall_names[num], p -> trapframe -> a0);
    80001d4a:	6cb8                	ld	a4,88(s1)
    80001d4c:	098e                	slli	s3,s3,0x3
    80001d4e:	00006797          	auipc	a5,0x6
    80001d52:	b2a78793          	addi	a5,a5,-1238 # 80007878 <syscalls>
    80001d56:	97ce                	add	a5,a5,s3
    80001d58:	7b34                	ld	a3,112(a4)
    80001d5a:	63f0                	ld	a2,192(a5)
    80001d5c:	588c                	lw	a1,48(s1)
    80001d5e:	00005517          	auipc	a0,0x5
    80001d62:	65250513          	addi	a0,a0,1618 # 800073b0 <etext+0x3b0>
    80001d66:	52a030ef          	jal	80005290 <printf>
    80001d6a:	a831                	j	80001d86 <syscall+0x86>
    }

  } else {
    printf("%d %s: unknown sys call %d\n",
    80001d6c:	86ce                	mv	a3,s3
    80001d6e:	15848613          	addi	a2,s1,344
    80001d72:	588c                	lw	a1,48(s1)
    80001d74:	00005517          	auipc	a0,0x5
    80001d78:	65450513          	addi	a0,a0,1620 # 800073c8 <etext+0x3c8>
    80001d7c:	514030ef          	jal	80005290 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80001d80:	6cbc                	ld	a5,88(s1)
    80001d82:	577d                	li	a4,-1
    80001d84:	fbb8                	sd	a4,112(a5)
  }
}
    80001d86:	70a2                	ld	ra,40(sp)
    80001d88:	7402                	ld	s0,32(sp)
    80001d8a:	64e2                	ld	s1,24(sp)
    80001d8c:	6942                	ld	s2,16(sp)
    80001d8e:	69a2                	ld	s3,8(sp)
    80001d90:	6145                	addi	sp,sp,48
    80001d92:	8082                	ret

0000000080001d94 <sys_exit>:
#include "proc.h"
#include "sysinfo.h"

uint64
sys_exit(void)
{
    80001d94:	1101                	addi	sp,sp,-32
    80001d96:	ec06                	sd	ra,24(sp)
    80001d98:	e822                	sd	s0,16(sp)
    80001d9a:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80001d9c:	fec40593          	addi	a1,s0,-20
    80001da0:	4501                	li	a0,0
    80001da2:	ef7ff0ef          	jal	80001c98 <argint>
  exit(n);
    80001da6:	fec42503          	lw	a0,-20(s0)
    80001daa:	ec8ff0ef          	jal	80001472 <exit>
  return 0;  // not reached
}
    80001dae:	4501                	li	a0,0
    80001db0:	60e2                	ld	ra,24(sp)
    80001db2:	6442                	ld	s0,16(sp)
    80001db4:	6105                	addi	sp,sp,32
    80001db6:	8082                	ret

0000000080001db8 <sys_getpid>:

uint64
sys_getpid(void)
{
    80001db8:	1141                	addi	sp,sp,-16
    80001dba:	e406                	sd	ra,8(sp)
    80001dbc:	e022                	sd	s0,0(sp)
    80001dbe:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80001dc0:	fd9fe0ef          	jal	80000d98 <myproc>
}
    80001dc4:	5908                	lw	a0,48(a0)
    80001dc6:	60a2                	ld	ra,8(sp)
    80001dc8:	6402                	ld	s0,0(sp)
    80001dca:	0141                	addi	sp,sp,16
    80001dcc:	8082                	ret

0000000080001dce <sys_fork>:

uint64
sys_fork(void)
{
    80001dce:	1141                	addi	sp,sp,-16
    80001dd0:	e406                	sd	ra,8(sp)
    80001dd2:	e022                	sd	s0,0(sp)
    80001dd4:	0800                	addi	s0,sp,16
  return fork();
    80001dd6:	ae8ff0ef          	jal	800010be <fork>
}
    80001dda:	60a2                	ld	ra,8(sp)
    80001ddc:	6402                	ld	s0,0(sp)
    80001dde:	0141                	addi	sp,sp,16
    80001de0:	8082                	ret

0000000080001de2 <sys_wait>:

uint64
sys_wait(void)
{
    80001de2:	1101                	addi	sp,sp,-32
    80001de4:	ec06                	sd	ra,24(sp)
    80001de6:	e822                	sd	s0,16(sp)
    80001de8:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80001dea:	fe840593          	addi	a1,s0,-24
    80001dee:	4501                	li	a0,0
    80001df0:	ec5ff0ef          	jal	80001cb4 <argaddr>
  return wait(p);
    80001df4:	fe843503          	ld	a0,-24(s0)
    80001df8:	fd0ff0ef          	jal	800015c8 <wait>
}
    80001dfc:	60e2                	ld	ra,24(sp)
    80001dfe:	6442                	ld	s0,16(sp)
    80001e00:	6105                	addi	sp,sp,32
    80001e02:	8082                	ret

0000000080001e04 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80001e04:	7179                	addi	sp,sp,-48
    80001e06:	f406                	sd	ra,40(sp)
    80001e08:	f022                	sd	s0,32(sp)
    80001e0a:	ec26                	sd	s1,24(sp)
    80001e0c:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80001e0e:	fdc40593          	addi	a1,s0,-36
    80001e12:	4501                	li	a0,0
    80001e14:	e85ff0ef          	jal	80001c98 <argint>
  addr = myproc()->sz;
    80001e18:	f81fe0ef          	jal	80000d98 <myproc>
    80001e1c:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80001e1e:	fdc42503          	lw	a0,-36(s0)
    80001e22:	a4cff0ef          	jal	8000106e <growproc>
    80001e26:	00054863          	bltz	a0,80001e36 <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80001e2a:	8526                	mv	a0,s1
    80001e2c:	70a2                	ld	ra,40(sp)
    80001e2e:	7402                	ld	s0,32(sp)
    80001e30:	64e2                	ld	s1,24(sp)
    80001e32:	6145                	addi	sp,sp,48
    80001e34:	8082                	ret
    return -1;
    80001e36:	54fd                	li	s1,-1
    80001e38:	bfcd                	j	80001e2a <sys_sbrk+0x26>

0000000080001e3a <sys_sleep>:

uint64
sys_sleep(void)
{
    80001e3a:	7139                	addi	sp,sp,-64
    80001e3c:	fc06                	sd	ra,56(sp)
    80001e3e:	f822                	sd	s0,48(sp)
    80001e40:	f04a                	sd	s2,32(sp)
    80001e42:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80001e44:	fcc40593          	addi	a1,s0,-52
    80001e48:	4501                	li	a0,0
    80001e4a:	e4fff0ef          	jal	80001c98 <argint>
  if(n < 0)
    80001e4e:	fcc42783          	lw	a5,-52(s0)
    80001e52:	0607c763          	bltz	a5,80001ec0 <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80001e56:	0000e517          	auipc	a0,0xe
    80001e5a:	47a50513          	addi	a0,a0,1146 # 800102d0 <tickslock>
    80001e5e:	233030ef          	jal	80005890 <acquire>
  ticks0 = ticks;
    80001e62:	00008917          	auipc	s2,0x8
    80001e66:	60692903          	lw	s2,1542(s2) # 8000a468 <ticks>
  while(ticks - ticks0 < n){
    80001e6a:	fcc42783          	lw	a5,-52(s0)
    80001e6e:	cf8d                	beqz	a5,80001ea8 <sys_sleep+0x6e>
    80001e70:	f426                	sd	s1,40(sp)
    80001e72:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80001e74:	0000e997          	auipc	s3,0xe
    80001e78:	45c98993          	addi	s3,s3,1116 # 800102d0 <tickslock>
    80001e7c:	00008497          	auipc	s1,0x8
    80001e80:	5ec48493          	addi	s1,s1,1516 # 8000a468 <ticks>
    if(killed(myproc())){
    80001e84:	f15fe0ef          	jal	80000d98 <myproc>
    80001e88:	f16ff0ef          	jal	8000159e <killed>
    80001e8c:	ed0d                	bnez	a0,80001ec6 <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80001e8e:	85ce                	mv	a1,s3
    80001e90:	8526                	mv	a0,s1
    80001e92:	cd4ff0ef          	jal	80001366 <sleep>
  while(ticks - ticks0 < n){
    80001e96:	409c                	lw	a5,0(s1)
    80001e98:	412787bb          	subw	a5,a5,s2
    80001e9c:	fcc42703          	lw	a4,-52(s0)
    80001ea0:	fee7e2e3          	bltu	a5,a4,80001e84 <sys_sleep+0x4a>
    80001ea4:	74a2                	ld	s1,40(sp)
    80001ea6:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80001ea8:	0000e517          	auipc	a0,0xe
    80001eac:	42850513          	addi	a0,a0,1064 # 800102d0 <tickslock>
    80001eb0:	279030ef          	jal	80005928 <release>
  return 0;
    80001eb4:	4501                	li	a0,0
}
    80001eb6:	70e2                	ld	ra,56(sp)
    80001eb8:	7442                	ld	s0,48(sp)
    80001eba:	7902                	ld	s2,32(sp)
    80001ebc:	6121                	addi	sp,sp,64
    80001ebe:	8082                	ret
    n = 0;
    80001ec0:	fc042623          	sw	zero,-52(s0)
    80001ec4:	bf49                	j	80001e56 <sys_sleep+0x1c>
      release(&tickslock);
    80001ec6:	0000e517          	auipc	a0,0xe
    80001eca:	40a50513          	addi	a0,a0,1034 # 800102d0 <tickslock>
    80001ece:	25b030ef          	jal	80005928 <release>
      return -1;
    80001ed2:	557d                	li	a0,-1
    80001ed4:	74a2                	ld	s1,40(sp)
    80001ed6:	69e2                	ld	s3,24(sp)
    80001ed8:	bff9                	j	80001eb6 <sys_sleep+0x7c>

0000000080001eda <sys_kill>:

uint64
sys_kill(void)
{
    80001eda:	1101                	addi	sp,sp,-32
    80001edc:	ec06                	sd	ra,24(sp)
    80001ede:	e822                	sd	s0,16(sp)
    80001ee0:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80001ee2:	fec40593          	addi	a1,s0,-20
    80001ee6:	4501                	li	a0,0
    80001ee8:	db1ff0ef          	jal	80001c98 <argint>
  return kill(pid);
    80001eec:	fec42503          	lw	a0,-20(s0)
    80001ef0:	e24ff0ef          	jal	80001514 <kill>
}
    80001ef4:	60e2                	ld	ra,24(sp)
    80001ef6:	6442                	ld	s0,16(sp)
    80001ef8:	6105                	addi	sp,sp,32
    80001efa:	8082                	ret

0000000080001efc <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80001efc:	1101                	addi	sp,sp,-32
    80001efe:	ec06                	sd	ra,24(sp)
    80001f00:	e822                	sd	s0,16(sp)
    80001f02:	e426                	sd	s1,8(sp)
    80001f04:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80001f06:	0000e517          	auipc	a0,0xe
    80001f0a:	3ca50513          	addi	a0,a0,970 # 800102d0 <tickslock>
    80001f0e:	183030ef          	jal	80005890 <acquire>
  xticks = ticks;
    80001f12:	00008497          	auipc	s1,0x8
    80001f16:	5564a483          	lw	s1,1366(s1) # 8000a468 <ticks>
  release(&tickslock);
    80001f1a:	0000e517          	auipc	a0,0xe
    80001f1e:	3b650513          	addi	a0,a0,950 # 800102d0 <tickslock>
    80001f22:	207030ef          	jal	80005928 <release>
  return xticks;
}
    80001f26:	02049513          	slli	a0,s1,0x20
    80001f2a:	9101                	srli	a0,a0,0x20
    80001f2c:	60e2                	ld	ra,24(sp)
    80001f2e:	6442                	ld	s0,16(sp)
    80001f30:	64a2                	ld	s1,8(sp)
    80001f32:	6105                	addi	sp,sp,32
    80001f34:	8082                	ret

0000000080001f36 <sys_trace>:

uint64
sys_trace(void)
{
    80001f36:	1101                	addi	sp,sp,-32
    80001f38:	ec06                	sd	ra,24(sp)
    80001f3a:	e822                	sd	s0,16(sp)
    80001f3c:	1000                	addi	s0,sp,32
  int mask;

  argint(0, &mask);
    80001f3e:	fec40593          	addi	a1,s0,-20
    80001f42:	4501                	li	a0,0
    80001f44:	d55ff0ef          	jal	80001c98 <argint>
  myproc()->tracemask = mask;
    80001f48:	e51fe0ef          	jal	80000d98 <myproc>
    80001f4c:	fec42783          	lw	a5,-20(s0)
    80001f50:	d95c                	sw	a5,52(a0)

  return 0;
}
    80001f52:	4501                	li	a0,0
    80001f54:	60e2                	ld	ra,24(sp)
    80001f56:	6442                	ld	s0,16(sp)
    80001f58:	6105                	addi	sp,sp,32
    80001f5a:	8082                	ret

0000000080001f5c <sys_sysinfo>:

uint64
sys_sysinfo(void)
{
    80001f5c:	7179                	addi	sp,sp,-48
    80001f5e:	f406                	sd	ra,40(sp)
    80001f60:	f022                	sd	s0,32(sp)
    80001f62:	1800                	addi	s0,sp,48
  struct sysinfo info;
  uint64 addr;

  argaddr(0, &addr);
    80001f64:	fd040593          	addi	a1,s0,-48
    80001f68:	4501                	li	a0,0
    80001f6a:	d4bff0ef          	jal	80001cb4 <argaddr>

  info.freemem = freemem_count();
    80001f6e:	9c6fe0ef          	jal	80000134 <freemem_count>
    80001f72:	fca43c23          	sd	a0,-40(s0)
  info.nproc = nproc_count();
    80001f76:	885ff0ef          	jal	800017fa <nproc_count>
    80001f7a:	fea43023          	sd	a0,-32(s0)
  info.nopenfiles = nopenfiles_count();
    80001f7e:	79e010ef          	jal	8000371c <nopenfiles_count>
    80001f82:	fea43423          	sd	a0,-24(s0)

  if(copyout(myproc()->pagetable, addr, (char*)&info, sizeof(info)) < 0)
    80001f86:	e13fe0ef          	jal	80000d98 <myproc>
    80001f8a:	46e1                	li	a3,24
    80001f8c:	fd840613          	addi	a2,s0,-40
    80001f90:	fd043583          	ld	a1,-48(s0)
    80001f94:	6928                	ld	a0,80(a0)
    80001f96:	a73fe0ef          	jal	80000a08 <copyout>
    return -1;

  return 0;
}
    80001f9a:	957d                	srai	a0,a0,0x3f
    80001f9c:	70a2                	ld	ra,40(sp)
    80001f9e:	7402                	ld	s0,32(sp)
    80001fa0:	6145                	addi	sp,sp,48
    80001fa2:	8082                	ret

0000000080001fa4 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80001fa4:	7179                	addi	sp,sp,-48
    80001fa6:	f406                	sd	ra,40(sp)
    80001fa8:	f022                	sd	s0,32(sp)
    80001faa:	ec26                	sd	s1,24(sp)
    80001fac:	e84a                	sd	s2,16(sp)
    80001fae:	e44e                	sd	s3,8(sp)
    80001fb0:	e052                	sd	s4,0(sp)
    80001fb2:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80001fb4:	00005597          	auipc	a1,0x5
    80001fb8:	4e458593          	addi	a1,a1,1252 # 80007498 <etext+0x498>
    80001fbc:	0000e517          	auipc	a0,0xe
    80001fc0:	32c50513          	addi	a0,a0,812 # 800102e8 <bcache>
    80001fc4:	04d030ef          	jal	80005810 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80001fc8:	00016797          	auipc	a5,0x16
    80001fcc:	32078793          	addi	a5,a5,800 # 800182e8 <bcache+0x8000>
    80001fd0:	00016717          	auipc	a4,0x16
    80001fd4:	58070713          	addi	a4,a4,1408 # 80018550 <bcache+0x8268>
    80001fd8:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80001fdc:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80001fe0:	0000e497          	auipc	s1,0xe
    80001fe4:	32048493          	addi	s1,s1,800 # 80010300 <bcache+0x18>
    b->next = bcache.head.next;
    80001fe8:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80001fea:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80001fec:	00005a17          	auipc	s4,0x5
    80001ff0:	4b4a0a13          	addi	s4,s4,1204 # 800074a0 <etext+0x4a0>
    b->next = bcache.head.next;
    80001ff4:	2b893783          	ld	a5,696(s2)
    80001ff8:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80001ffa:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80001ffe:	85d2                	mv	a1,s4
    80002000:	01048513          	addi	a0,s1,16
    80002004:	248010ef          	jal	8000324c <initsleeplock>
    bcache.head.next->prev = b;
    80002008:	2b893783          	ld	a5,696(s2)
    8000200c:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000200e:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002012:	45848493          	addi	s1,s1,1112
    80002016:	fd349fe3          	bne	s1,s3,80001ff4 <binit+0x50>
  }
}
    8000201a:	70a2                	ld	ra,40(sp)
    8000201c:	7402                	ld	s0,32(sp)
    8000201e:	64e2                	ld	s1,24(sp)
    80002020:	6942                	ld	s2,16(sp)
    80002022:	69a2                	ld	s3,8(sp)
    80002024:	6a02                	ld	s4,0(sp)
    80002026:	6145                	addi	sp,sp,48
    80002028:	8082                	ret

000000008000202a <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000202a:	7179                	addi	sp,sp,-48
    8000202c:	f406                	sd	ra,40(sp)
    8000202e:	f022                	sd	s0,32(sp)
    80002030:	ec26                	sd	s1,24(sp)
    80002032:	e84a                	sd	s2,16(sp)
    80002034:	e44e                	sd	s3,8(sp)
    80002036:	1800                	addi	s0,sp,48
    80002038:	892a                	mv	s2,a0
    8000203a:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000203c:	0000e517          	auipc	a0,0xe
    80002040:	2ac50513          	addi	a0,a0,684 # 800102e8 <bcache>
    80002044:	04d030ef          	jal	80005890 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002048:	00016497          	auipc	s1,0x16
    8000204c:	5584b483          	ld	s1,1368(s1) # 800185a0 <bcache+0x82b8>
    80002050:	00016797          	auipc	a5,0x16
    80002054:	50078793          	addi	a5,a5,1280 # 80018550 <bcache+0x8268>
    80002058:	02f48b63          	beq	s1,a5,8000208e <bread+0x64>
    8000205c:	873e                	mv	a4,a5
    8000205e:	a021                	j	80002066 <bread+0x3c>
    80002060:	68a4                	ld	s1,80(s1)
    80002062:	02e48663          	beq	s1,a4,8000208e <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002066:	449c                	lw	a5,8(s1)
    80002068:	ff279ce3          	bne	a5,s2,80002060 <bread+0x36>
    8000206c:	44dc                	lw	a5,12(s1)
    8000206e:	ff3799e3          	bne	a5,s3,80002060 <bread+0x36>
      b->refcnt++;
    80002072:	40bc                	lw	a5,64(s1)
    80002074:	2785                	addiw	a5,a5,1
    80002076:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002078:	0000e517          	auipc	a0,0xe
    8000207c:	27050513          	addi	a0,a0,624 # 800102e8 <bcache>
    80002080:	0a9030ef          	jal	80005928 <release>
      acquiresleep(&b->lock);
    80002084:	01048513          	addi	a0,s1,16
    80002088:	1fa010ef          	jal	80003282 <acquiresleep>
      return b;
    8000208c:	a889                	j	800020de <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000208e:	00016497          	auipc	s1,0x16
    80002092:	50a4b483          	ld	s1,1290(s1) # 80018598 <bcache+0x82b0>
    80002096:	00016797          	auipc	a5,0x16
    8000209a:	4ba78793          	addi	a5,a5,1210 # 80018550 <bcache+0x8268>
    8000209e:	00f48863          	beq	s1,a5,800020ae <bread+0x84>
    800020a2:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800020a4:	40bc                	lw	a5,64(s1)
    800020a6:	cb91                	beqz	a5,800020ba <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800020a8:	64a4                	ld	s1,72(s1)
    800020aa:	fee49de3          	bne	s1,a4,800020a4 <bread+0x7a>
  panic("bget: no buffers");
    800020ae:	00005517          	auipc	a0,0x5
    800020b2:	3fa50513          	addi	a0,a0,1018 # 800074a8 <etext+0x4a8>
    800020b6:	4ac030ef          	jal	80005562 <panic>
      b->dev = dev;
    800020ba:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800020be:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800020c2:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800020c6:	4785                	li	a5,1
    800020c8:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800020ca:	0000e517          	auipc	a0,0xe
    800020ce:	21e50513          	addi	a0,a0,542 # 800102e8 <bcache>
    800020d2:	057030ef          	jal	80005928 <release>
      acquiresleep(&b->lock);
    800020d6:	01048513          	addi	a0,s1,16
    800020da:	1a8010ef          	jal	80003282 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800020de:	409c                	lw	a5,0(s1)
    800020e0:	cb89                	beqz	a5,800020f2 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800020e2:	8526                	mv	a0,s1
    800020e4:	70a2                	ld	ra,40(sp)
    800020e6:	7402                	ld	s0,32(sp)
    800020e8:	64e2                	ld	s1,24(sp)
    800020ea:	6942                	ld	s2,16(sp)
    800020ec:	69a2                	ld	s3,8(sp)
    800020ee:	6145                	addi	sp,sp,48
    800020f0:	8082                	ret
    virtio_disk_rw(b, 0);
    800020f2:	4581                	li	a1,0
    800020f4:	8526                	mv	a0,s1
    800020f6:	23b020ef          	jal	80004b30 <virtio_disk_rw>
    b->valid = 1;
    800020fa:	4785                	li	a5,1
    800020fc:	c09c                	sw	a5,0(s1)
  return b;
    800020fe:	b7d5                	j	800020e2 <bread+0xb8>

0000000080002100 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002100:	1101                	addi	sp,sp,-32
    80002102:	ec06                	sd	ra,24(sp)
    80002104:	e822                	sd	s0,16(sp)
    80002106:	e426                	sd	s1,8(sp)
    80002108:	1000                	addi	s0,sp,32
    8000210a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000210c:	0541                	addi	a0,a0,16
    8000210e:	1f2010ef          	jal	80003300 <holdingsleep>
    80002112:	c911                	beqz	a0,80002126 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002114:	4585                	li	a1,1
    80002116:	8526                	mv	a0,s1
    80002118:	219020ef          	jal	80004b30 <virtio_disk_rw>
}
    8000211c:	60e2                	ld	ra,24(sp)
    8000211e:	6442                	ld	s0,16(sp)
    80002120:	64a2                	ld	s1,8(sp)
    80002122:	6105                	addi	sp,sp,32
    80002124:	8082                	ret
    panic("bwrite");
    80002126:	00005517          	auipc	a0,0x5
    8000212a:	39a50513          	addi	a0,a0,922 # 800074c0 <etext+0x4c0>
    8000212e:	434030ef          	jal	80005562 <panic>

0000000080002132 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002132:	1101                	addi	sp,sp,-32
    80002134:	ec06                	sd	ra,24(sp)
    80002136:	e822                	sd	s0,16(sp)
    80002138:	e426                	sd	s1,8(sp)
    8000213a:	e04a                	sd	s2,0(sp)
    8000213c:	1000                	addi	s0,sp,32
    8000213e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002140:	01050913          	addi	s2,a0,16
    80002144:	854a                	mv	a0,s2
    80002146:	1ba010ef          	jal	80003300 <holdingsleep>
    8000214a:	c135                	beqz	a0,800021ae <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    8000214c:	854a                	mv	a0,s2
    8000214e:	17a010ef          	jal	800032c8 <releasesleep>

  acquire(&bcache.lock);
    80002152:	0000e517          	auipc	a0,0xe
    80002156:	19650513          	addi	a0,a0,406 # 800102e8 <bcache>
    8000215a:	736030ef          	jal	80005890 <acquire>
  b->refcnt--;
    8000215e:	40bc                	lw	a5,64(s1)
    80002160:	37fd                	addiw	a5,a5,-1
    80002162:	0007871b          	sext.w	a4,a5
    80002166:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002168:	e71d                	bnez	a4,80002196 <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000216a:	68b8                	ld	a4,80(s1)
    8000216c:	64bc                	ld	a5,72(s1)
    8000216e:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002170:	68b8                	ld	a4,80(s1)
    80002172:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002174:	00016797          	auipc	a5,0x16
    80002178:	17478793          	addi	a5,a5,372 # 800182e8 <bcache+0x8000>
    8000217c:	2b87b703          	ld	a4,696(a5)
    80002180:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002182:	00016717          	auipc	a4,0x16
    80002186:	3ce70713          	addi	a4,a4,974 # 80018550 <bcache+0x8268>
    8000218a:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000218c:	2b87b703          	ld	a4,696(a5)
    80002190:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002192:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002196:	0000e517          	auipc	a0,0xe
    8000219a:	15250513          	addi	a0,a0,338 # 800102e8 <bcache>
    8000219e:	78a030ef          	jal	80005928 <release>
}
    800021a2:	60e2                	ld	ra,24(sp)
    800021a4:	6442                	ld	s0,16(sp)
    800021a6:	64a2                	ld	s1,8(sp)
    800021a8:	6902                	ld	s2,0(sp)
    800021aa:	6105                	addi	sp,sp,32
    800021ac:	8082                	ret
    panic("brelse");
    800021ae:	00005517          	auipc	a0,0x5
    800021b2:	31a50513          	addi	a0,a0,794 # 800074c8 <etext+0x4c8>
    800021b6:	3ac030ef          	jal	80005562 <panic>

00000000800021ba <bpin>:

void
bpin(struct buf *b) {
    800021ba:	1101                	addi	sp,sp,-32
    800021bc:	ec06                	sd	ra,24(sp)
    800021be:	e822                	sd	s0,16(sp)
    800021c0:	e426                	sd	s1,8(sp)
    800021c2:	1000                	addi	s0,sp,32
    800021c4:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800021c6:	0000e517          	auipc	a0,0xe
    800021ca:	12250513          	addi	a0,a0,290 # 800102e8 <bcache>
    800021ce:	6c2030ef          	jal	80005890 <acquire>
  b->refcnt++;
    800021d2:	40bc                	lw	a5,64(s1)
    800021d4:	2785                	addiw	a5,a5,1
    800021d6:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800021d8:	0000e517          	auipc	a0,0xe
    800021dc:	11050513          	addi	a0,a0,272 # 800102e8 <bcache>
    800021e0:	748030ef          	jal	80005928 <release>
}
    800021e4:	60e2                	ld	ra,24(sp)
    800021e6:	6442                	ld	s0,16(sp)
    800021e8:	64a2                	ld	s1,8(sp)
    800021ea:	6105                	addi	sp,sp,32
    800021ec:	8082                	ret

00000000800021ee <bunpin>:

void
bunpin(struct buf *b) {
    800021ee:	1101                	addi	sp,sp,-32
    800021f0:	ec06                	sd	ra,24(sp)
    800021f2:	e822                	sd	s0,16(sp)
    800021f4:	e426                	sd	s1,8(sp)
    800021f6:	1000                	addi	s0,sp,32
    800021f8:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800021fa:	0000e517          	auipc	a0,0xe
    800021fe:	0ee50513          	addi	a0,a0,238 # 800102e8 <bcache>
    80002202:	68e030ef          	jal	80005890 <acquire>
  b->refcnt--;
    80002206:	40bc                	lw	a5,64(s1)
    80002208:	37fd                	addiw	a5,a5,-1
    8000220a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000220c:	0000e517          	auipc	a0,0xe
    80002210:	0dc50513          	addi	a0,a0,220 # 800102e8 <bcache>
    80002214:	714030ef          	jal	80005928 <release>
}
    80002218:	60e2                	ld	ra,24(sp)
    8000221a:	6442                	ld	s0,16(sp)
    8000221c:	64a2                	ld	s1,8(sp)
    8000221e:	6105                	addi	sp,sp,32
    80002220:	8082                	ret

0000000080002222 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002222:	1101                	addi	sp,sp,-32
    80002224:	ec06                	sd	ra,24(sp)
    80002226:	e822                	sd	s0,16(sp)
    80002228:	e426                	sd	s1,8(sp)
    8000222a:	e04a                	sd	s2,0(sp)
    8000222c:	1000                	addi	s0,sp,32
    8000222e:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002230:	00d5d59b          	srliw	a1,a1,0xd
    80002234:	00016797          	auipc	a5,0x16
    80002238:	7907a783          	lw	a5,1936(a5) # 800189c4 <sb+0x1c>
    8000223c:	9dbd                	addw	a1,a1,a5
    8000223e:	dedff0ef          	jal	8000202a <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002242:	0074f713          	andi	a4,s1,7
    80002246:	4785                	li	a5,1
    80002248:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000224c:	14ce                	slli	s1,s1,0x33
    8000224e:	90d9                	srli	s1,s1,0x36
    80002250:	00950733          	add	a4,a0,s1
    80002254:	05874703          	lbu	a4,88(a4)
    80002258:	00e7f6b3          	and	a3,a5,a4
    8000225c:	c29d                	beqz	a3,80002282 <bfree+0x60>
    8000225e:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002260:	94aa                	add	s1,s1,a0
    80002262:	fff7c793          	not	a5,a5
    80002266:	8f7d                	and	a4,a4,a5
    80002268:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000226c:	711000ef          	jal	8000317c <log_write>
  brelse(bp);
    80002270:	854a                	mv	a0,s2
    80002272:	ec1ff0ef          	jal	80002132 <brelse>
}
    80002276:	60e2                	ld	ra,24(sp)
    80002278:	6442                	ld	s0,16(sp)
    8000227a:	64a2                	ld	s1,8(sp)
    8000227c:	6902                	ld	s2,0(sp)
    8000227e:	6105                	addi	sp,sp,32
    80002280:	8082                	ret
    panic("freeing free block");
    80002282:	00005517          	auipc	a0,0x5
    80002286:	24e50513          	addi	a0,a0,590 # 800074d0 <etext+0x4d0>
    8000228a:	2d8030ef          	jal	80005562 <panic>

000000008000228e <balloc>:
{
    8000228e:	711d                	addi	sp,sp,-96
    80002290:	ec86                	sd	ra,88(sp)
    80002292:	e8a2                	sd	s0,80(sp)
    80002294:	e4a6                	sd	s1,72(sp)
    80002296:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002298:	00016797          	auipc	a5,0x16
    8000229c:	7147a783          	lw	a5,1812(a5) # 800189ac <sb+0x4>
    800022a0:	0e078f63          	beqz	a5,8000239e <balloc+0x110>
    800022a4:	e0ca                	sd	s2,64(sp)
    800022a6:	fc4e                	sd	s3,56(sp)
    800022a8:	f852                	sd	s4,48(sp)
    800022aa:	f456                	sd	s5,40(sp)
    800022ac:	f05a                	sd	s6,32(sp)
    800022ae:	ec5e                	sd	s7,24(sp)
    800022b0:	e862                	sd	s8,16(sp)
    800022b2:	e466                	sd	s9,8(sp)
    800022b4:	8baa                	mv	s7,a0
    800022b6:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800022b8:	00016b17          	auipc	s6,0x16
    800022bc:	6f0b0b13          	addi	s6,s6,1776 # 800189a8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800022c0:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800022c2:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800022c4:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800022c6:	6c89                	lui	s9,0x2
    800022c8:	a0b5                	j	80002334 <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    800022ca:	97ca                	add	a5,a5,s2
    800022cc:	8e55                	or	a2,a2,a3
    800022ce:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800022d2:	854a                	mv	a0,s2
    800022d4:	6a9000ef          	jal	8000317c <log_write>
        brelse(bp);
    800022d8:	854a                	mv	a0,s2
    800022da:	e59ff0ef          	jal	80002132 <brelse>
  bp = bread(dev, bno);
    800022de:	85a6                	mv	a1,s1
    800022e0:	855e                	mv	a0,s7
    800022e2:	d49ff0ef          	jal	8000202a <bread>
    800022e6:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800022e8:	40000613          	li	a2,1024
    800022ec:	4581                	li	a1,0
    800022ee:	05850513          	addi	a0,a0,88
    800022f2:	e85fd0ef          	jal	80000176 <memset>
  log_write(bp);
    800022f6:	854a                	mv	a0,s2
    800022f8:	685000ef          	jal	8000317c <log_write>
  brelse(bp);
    800022fc:	854a                	mv	a0,s2
    800022fe:	e35ff0ef          	jal	80002132 <brelse>
}
    80002302:	6906                	ld	s2,64(sp)
    80002304:	79e2                	ld	s3,56(sp)
    80002306:	7a42                	ld	s4,48(sp)
    80002308:	7aa2                	ld	s5,40(sp)
    8000230a:	7b02                	ld	s6,32(sp)
    8000230c:	6be2                	ld	s7,24(sp)
    8000230e:	6c42                	ld	s8,16(sp)
    80002310:	6ca2                	ld	s9,8(sp)
}
    80002312:	8526                	mv	a0,s1
    80002314:	60e6                	ld	ra,88(sp)
    80002316:	6446                	ld	s0,80(sp)
    80002318:	64a6                	ld	s1,72(sp)
    8000231a:	6125                	addi	sp,sp,96
    8000231c:	8082                	ret
    brelse(bp);
    8000231e:	854a                	mv	a0,s2
    80002320:	e13ff0ef          	jal	80002132 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002324:	015c87bb          	addw	a5,s9,s5
    80002328:	00078a9b          	sext.w	s5,a5
    8000232c:	004b2703          	lw	a4,4(s6)
    80002330:	04eaff63          	bgeu	s5,a4,8000238e <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    80002334:	41fad79b          	sraiw	a5,s5,0x1f
    80002338:	0137d79b          	srliw	a5,a5,0x13
    8000233c:	015787bb          	addw	a5,a5,s5
    80002340:	40d7d79b          	sraiw	a5,a5,0xd
    80002344:	01cb2583          	lw	a1,28(s6)
    80002348:	9dbd                	addw	a1,a1,a5
    8000234a:	855e                	mv	a0,s7
    8000234c:	cdfff0ef          	jal	8000202a <bread>
    80002350:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002352:	004b2503          	lw	a0,4(s6)
    80002356:	000a849b          	sext.w	s1,s5
    8000235a:	8762                	mv	a4,s8
    8000235c:	fca4f1e3          	bgeu	s1,a0,8000231e <balloc+0x90>
      m = 1 << (bi % 8);
    80002360:	00777693          	andi	a3,a4,7
    80002364:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002368:	41f7579b          	sraiw	a5,a4,0x1f
    8000236c:	01d7d79b          	srliw	a5,a5,0x1d
    80002370:	9fb9                	addw	a5,a5,a4
    80002372:	4037d79b          	sraiw	a5,a5,0x3
    80002376:	00f90633          	add	a2,s2,a5
    8000237a:	05864603          	lbu	a2,88(a2)
    8000237e:	00c6f5b3          	and	a1,a3,a2
    80002382:	d5a1                	beqz	a1,800022ca <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002384:	2705                	addiw	a4,a4,1
    80002386:	2485                	addiw	s1,s1,1
    80002388:	fd471ae3          	bne	a4,s4,8000235c <balloc+0xce>
    8000238c:	bf49                	j	8000231e <balloc+0x90>
    8000238e:	6906                	ld	s2,64(sp)
    80002390:	79e2                	ld	s3,56(sp)
    80002392:	7a42                	ld	s4,48(sp)
    80002394:	7aa2                	ld	s5,40(sp)
    80002396:	7b02                	ld	s6,32(sp)
    80002398:	6be2                	ld	s7,24(sp)
    8000239a:	6c42                	ld	s8,16(sp)
    8000239c:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    8000239e:	00005517          	auipc	a0,0x5
    800023a2:	14a50513          	addi	a0,a0,330 # 800074e8 <etext+0x4e8>
    800023a6:	6eb020ef          	jal	80005290 <printf>
  return 0;
    800023aa:	4481                	li	s1,0
    800023ac:	b79d                	j	80002312 <balloc+0x84>

00000000800023ae <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800023ae:	7179                	addi	sp,sp,-48
    800023b0:	f406                	sd	ra,40(sp)
    800023b2:	f022                	sd	s0,32(sp)
    800023b4:	ec26                	sd	s1,24(sp)
    800023b6:	e84a                	sd	s2,16(sp)
    800023b8:	e44e                	sd	s3,8(sp)
    800023ba:	1800                	addi	s0,sp,48
    800023bc:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800023be:	47ad                	li	a5,11
    800023c0:	02b7e663          	bltu	a5,a1,800023ec <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    800023c4:	02059793          	slli	a5,a1,0x20
    800023c8:	01e7d593          	srli	a1,a5,0x1e
    800023cc:	00b504b3          	add	s1,a0,a1
    800023d0:	0504a903          	lw	s2,80(s1)
    800023d4:	06091a63          	bnez	s2,80002448 <bmap+0x9a>
      addr = balloc(ip->dev);
    800023d8:	4108                	lw	a0,0(a0)
    800023da:	eb5ff0ef          	jal	8000228e <balloc>
    800023de:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800023e2:	06090363          	beqz	s2,80002448 <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    800023e6:	0524a823          	sw	s2,80(s1)
    800023ea:	a8b9                	j	80002448 <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    800023ec:	ff45849b          	addiw	s1,a1,-12
    800023f0:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800023f4:	0ff00793          	li	a5,255
    800023f8:	06e7ee63          	bltu	a5,a4,80002474 <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800023fc:	08052903          	lw	s2,128(a0)
    80002400:	00091d63          	bnez	s2,8000241a <bmap+0x6c>
      addr = balloc(ip->dev);
    80002404:	4108                	lw	a0,0(a0)
    80002406:	e89ff0ef          	jal	8000228e <balloc>
    8000240a:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000240e:	02090d63          	beqz	s2,80002448 <bmap+0x9a>
    80002412:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002414:	0929a023          	sw	s2,128(s3)
    80002418:	a011                	j	8000241c <bmap+0x6e>
    8000241a:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    8000241c:	85ca                	mv	a1,s2
    8000241e:	0009a503          	lw	a0,0(s3)
    80002422:	c09ff0ef          	jal	8000202a <bread>
    80002426:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002428:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000242c:	02049713          	slli	a4,s1,0x20
    80002430:	01e75593          	srli	a1,a4,0x1e
    80002434:	00b784b3          	add	s1,a5,a1
    80002438:	0004a903          	lw	s2,0(s1)
    8000243c:	00090e63          	beqz	s2,80002458 <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002440:	8552                	mv	a0,s4
    80002442:	cf1ff0ef          	jal	80002132 <brelse>
    return addr;
    80002446:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002448:	854a                	mv	a0,s2
    8000244a:	70a2                	ld	ra,40(sp)
    8000244c:	7402                	ld	s0,32(sp)
    8000244e:	64e2                	ld	s1,24(sp)
    80002450:	6942                	ld	s2,16(sp)
    80002452:	69a2                	ld	s3,8(sp)
    80002454:	6145                	addi	sp,sp,48
    80002456:	8082                	ret
      addr = balloc(ip->dev);
    80002458:	0009a503          	lw	a0,0(s3)
    8000245c:	e33ff0ef          	jal	8000228e <balloc>
    80002460:	0005091b          	sext.w	s2,a0
      if(addr){
    80002464:	fc090ee3          	beqz	s2,80002440 <bmap+0x92>
        a[bn] = addr;
    80002468:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    8000246c:	8552                	mv	a0,s4
    8000246e:	50f000ef          	jal	8000317c <log_write>
    80002472:	b7f9                	j	80002440 <bmap+0x92>
    80002474:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80002476:	00005517          	auipc	a0,0x5
    8000247a:	08a50513          	addi	a0,a0,138 # 80007500 <etext+0x500>
    8000247e:	0e4030ef          	jal	80005562 <panic>

0000000080002482 <iget>:
{
    80002482:	7179                	addi	sp,sp,-48
    80002484:	f406                	sd	ra,40(sp)
    80002486:	f022                	sd	s0,32(sp)
    80002488:	ec26                	sd	s1,24(sp)
    8000248a:	e84a                	sd	s2,16(sp)
    8000248c:	e44e                	sd	s3,8(sp)
    8000248e:	e052                	sd	s4,0(sp)
    80002490:	1800                	addi	s0,sp,48
    80002492:	89aa                	mv	s3,a0
    80002494:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002496:	00016517          	auipc	a0,0x16
    8000249a:	53250513          	addi	a0,a0,1330 # 800189c8 <itable>
    8000249e:	3f2030ef          	jal	80005890 <acquire>
  empty = 0;
    800024a2:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800024a4:	00016497          	auipc	s1,0x16
    800024a8:	53c48493          	addi	s1,s1,1340 # 800189e0 <itable+0x18>
    800024ac:	00018697          	auipc	a3,0x18
    800024b0:	fc468693          	addi	a3,a3,-60 # 8001a470 <log>
    800024b4:	a039                	j	800024c2 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800024b6:	02090963          	beqz	s2,800024e8 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800024ba:	08848493          	addi	s1,s1,136
    800024be:	02d48863          	beq	s1,a3,800024ee <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800024c2:	449c                	lw	a5,8(s1)
    800024c4:	fef059e3          	blez	a5,800024b6 <iget+0x34>
    800024c8:	4098                	lw	a4,0(s1)
    800024ca:	ff3716e3          	bne	a4,s3,800024b6 <iget+0x34>
    800024ce:	40d8                	lw	a4,4(s1)
    800024d0:	ff4713e3          	bne	a4,s4,800024b6 <iget+0x34>
      ip->ref++;
    800024d4:	2785                	addiw	a5,a5,1
    800024d6:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800024d8:	00016517          	auipc	a0,0x16
    800024dc:	4f050513          	addi	a0,a0,1264 # 800189c8 <itable>
    800024e0:	448030ef          	jal	80005928 <release>
      return ip;
    800024e4:	8926                	mv	s2,s1
    800024e6:	a02d                	j	80002510 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800024e8:	fbe9                	bnez	a5,800024ba <iget+0x38>
      empty = ip;
    800024ea:	8926                	mv	s2,s1
    800024ec:	b7f9                	j	800024ba <iget+0x38>
  if(empty == 0)
    800024ee:	02090a63          	beqz	s2,80002522 <iget+0xa0>
  ip->dev = dev;
    800024f2:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800024f6:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800024fa:	4785                	li	a5,1
    800024fc:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002500:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002504:	00016517          	auipc	a0,0x16
    80002508:	4c450513          	addi	a0,a0,1220 # 800189c8 <itable>
    8000250c:	41c030ef          	jal	80005928 <release>
}
    80002510:	854a                	mv	a0,s2
    80002512:	70a2                	ld	ra,40(sp)
    80002514:	7402                	ld	s0,32(sp)
    80002516:	64e2                	ld	s1,24(sp)
    80002518:	6942                	ld	s2,16(sp)
    8000251a:	69a2                	ld	s3,8(sp)
    8000251c:	6a02                	ld	s4,0(sp)
    8000251e:	6145                	addi	sp,sp,48
    80002520:	8082                	ret
    panic("iget: no inodes");
    80002522:	00005517          	auipc	a0,0x5
    80002526:	ff650513          	addi	a0,a0,-10 # 80007518 <etext+0x518>
    8000252a:	038030ef          	jal	80005562 <panic>

000000008000252e <fsinit>:
fsinit(int dev) {
    8000252e:	7179                	addi	sp,sp,-48
    80002530:	f406                	sd	ra,40(sp)
    80002532:	f022                	sd	s0,32(sp)
    80002534:	ec26                	sd	s1,24(sp)
    80002536:	e84a                	sd	s2,16(sp)
    80002538:	e44e                	sd	s3,8(sp)
    8000253a:	1800                	addi	s0,sp,48
    8000253c:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000253e:	4585                	li	a1,1
    80002540:	aebff0ef          	jal	8000202a <bread>
    80002544:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002546:	00016997          	auipc	s3,0x16
    8000254a:	46298993          	addi	s3,s3,1122 # 800189a8 <sb>
    8000254e:	02000613          	li	a2,32
    80002552:	05850593          	addi	a1,a0,88
    80002556:	854e                	mv	a0,s3
    80002558:	c7bfd0ef          	jal	800001d2 <memmove>
  brelse(bp);
    8000255c:	8526                	mv	a0,s1
    8000255e:	bd5ff0ef          	jal	80002132 <brelse>
  if(sb.magic != FSMAGIC)
    80002562:	0009a703          	lw	a4,0(s3)
    80002566:	102037b7          	lui	a5,0x10203
    8000256a:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000256e:	02f71063          	bne	a4,a5,8000258e <fsinit+0x60>
  initlog(dev, &sb);
    80002572:	00016597          	auipc	a1,0x16
    80002576:	43658593          	addi	a1,a1,1078 # 800189a8 <sb>
    8000257a:	854a                	mv	a0,s2
    8000257c:	1f9000ef          	jal	80002f74 <initlog>
}
    80002580:	70a2                	ld	ra,40(sp)
    80002582:	7402                	ld	s0,32(sp)
    80002584:	64e2                	ld	s1,24(sp)
    80002586:	6942                	ld	s2,16(sp)
    80002588:	69a2                	ld	s3,8(sp)
    8000258a:	6145                	addi	sp,sp,48
    8000258c:	8082                	ret
    panic("invalid file system");
    8000258e:	00005517          	auipc	a0,0x5
    80002592:	f9a50513          	addi	a0,a0,-102 # 80007528 <etext+0x528>
    80002596:	7cd020ef          	jal	80005562 <panic>

000000008000259a <iinit>:
{
    8000259a:	7179                	addi	sp,sp,-48
    8000259c:	f406                	sd	ra,40(sp)
    8000259e:	f022                	sd	s0,32(sp)
    800025a0:	ec26                	sd	s1,24(sp)
    800025a2:	e84a                	sd	s2,16(sp)
    800025a4:	e44e                	sd	s3,8(sp)
    800025a6:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800025a8:	00005597          	auipc	a1,0x5
    800025ac:	f9858593          	addi	a1,a1,-104 # 80007540 <etext+0x540>
    800025b0:	00016517          	auipc	a0,0x16
    800025b4:	41850513          	addi	a0,a0,1048 # 800189c8 <itable>
    800025b8:	258030ef          	jal	80005810 <initlock>
  for(i = 0; i < NINODE; i++) {
    800025bc:	00016497          	auipc	s1,0x16
    800025c0:	43448493          	addi	s1,s1,1076 # 800189f0 <itable+0x28>
    800025c4:	00018997          	auipc	s3,0x18
    800025c8:	ebc98993          	addi	s3,s3,-324 # 8001a480 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800025cc:	00005917          	auipc	s2,0x5
    800025d0:	f7c90913          	addi	s2,s2,-132 # 80007548 <etext+0x548>
    800025d4:	85ca                	mv	a1,s2
    800025d6:	8526                	mv	a0,s1
    800025d8:	475000ef          	jal	8000324c <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800025dc:	08848493          	addi	s1,s1,136
    800025e0:	ff349ae3          	bne	s1,s3,800025d4 <iinit+0x3a>
}
    800025e4:	70a2                	ld	ra,40(sp)
    800025e6:	7402                	ld	s0,32(sp)
    800025e8:	64e2                	ld	s1,24(sp)
    800025ea:	6942                	ld	s2,16(sp)
    800025ec:	69a2                	ld	s3,8(sp)
    800025ee:	6145                	addi	sp,sp,48
    800025f0:	8082                	ret

00000000800025f2 <ialloc>:
{
    800025f2:	7139                	addi	sp,sp,-64
    800025f4:	fc06                	sd	ra,56(sp)
    800025f6:	f822                	sd	s0,48(sp)
    800025f8:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800025fa:	00016717          	auipc	a4,0x16
    800025fe:	3ba72703          	lw	a4,954(a4) # 800189b4 <sb+0xc>
    80002602:	4785                	li	a5,1
    80002604:	06e7f063          	bgeu	a5,a4,80002664 <ialloc+0x72>
    80002608:	f426                	sd	s1,40(sp)
    8000260a:	f04a                	sd	s2,32(sp)
    8000260c:	ec4e                	sd	s3,24(sp)
    8000260e:	e852                	sd	s4,16(sp)
    80002610:	e456                	sd	s5,8(sp)
    80002612:	e05a                	sd	s6,0(sp)
    80002614:	8aaa                	mv	s5,a0
    80002616:	8b2e                	mv	s6,a1
    80002618:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    8000261a:	00016a17          	auipc	s4,0x16
    8000261e:	38ea0a13          	addi	s4,s4,910 # 800189a8 <sb>
    80002622:	00495593          	srli	a1,s2,0x4
    80002626:	018a2783          	lw	a5,24(s4)
    8000262a:	9dbd                	addw	a1,a1,a5
    8000262c:	8556                	mv	a0,s5
    8000262e:	9fdff0ef          	jal	8000202a <bread>
    80002632:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002634:	05850993          	addi	s3,a0,88
    80002638:	00f97793          	andi	a5,s2,15
    8000263c:	079a                	slli	a5,a5,0x6
    8000263e:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002640:	00099783          	lh	a5,0(s3)
    80002644:	cb9d                	beqz	a5,8000267a <ialloc+0x88>
    brelse(bp);
    80002646:	aedff0ef          	jal	80002132 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    8000264a:	0905                	addi	s2,s2,1
    8000264c:	00ca2703          	lw	a4,12(s4)
    80002650:	0009079b          	sext.w	a5,s2
    80002654:	fce7e7e3          	bltu	a5,a4,80002622 <ialloc+0x30>
    80002658:	74a2                	ld	s1,40(sp)
    8000265a:	7902                	ld	s2,32(sp)
    8000265c:	69e2                	ld	s3,24(sp)
    8000265e:	6a42                	ld	s4,16(sp)
    80002660:	6aa2                	ld	s5,8(sp)
    80002662:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80002664:	00005517          	auipc	a0,0x5
    80002668:	eec50513          	addi	a0,a0,-276 # 80007550 <etext+0x550>
    8000266c:	425020ef          	jal	80005290 <printf>
  return 0;
    80002670:	4501                	li	a0,0
}
    80002672:	70e2                	ld	ra,56(sp)
    80002674:	7442                	ld	s0,48(sp)
    80002676:	6121                	addi	sp,sp,64
    80002678:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    8000267a:	04000613          	li	a2,64
    8000267e:	4581                	li	a1,0
    80002680:	854e                	mv	a0,s3
    80002682:	af5fd0ef          	jal	80000176 <memset>
      dip->type = type;
    80002686:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    8000268a:	8526                	mv	a0,s1
    8000268c:	2f1000ef          	jal	8000317c <log_write>
      brelse(bp);
    80002690:	8526                	mv	a0,s1
    80002692:	aa1ff0ef          	jal	80002132 <brelse>
      return iget(dev, inum);
    80002696:	0009059b          	sext.w	a1,s2
    8000269a:	8556                	mv	a0,s5
    8000269c:	de7ff0ef          	jal	80002482 <iget>
    800026a0:	74a2                	ld	s1,40(sp)
    800026a2:	7902                	ld	s2,32(sp)
    800026a4:	69e2                	ld	s3,24(sp)
    800026a6:	6a42                	ld	s4,16(sp)
    800026a8:	6aa2                	ld	s5,8(sp)
    800026aa:	6b02                	ld	s6,0(sp)
    800026ac:	b7d9                	j	80002672 <ialloc+0x80>

00000000800026ae <iupdate>:
{
    800026ae:	1101                	addi	sp,sp,-32
    800026b0:	ec06                	sd	ra,24(sp)
    800026b2:	e822                	sd	s0,16(sp)
    800026b4:	e426                	sd	s1,8(sp)
    800026b6:	e04a                	sd	s2,0(sp)
    800026b8:	1000                	addi	s0,sp,32
    800026ba:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800026bc:	415c                	lw	a5,4(a0)
    800026be:	0047d79b          	srliw	a5,a5,0x4
    800026c2:	00016597          	auipc	a1,0x16
    800026c6:	2fe5a583          	lw	a1,766(a1) # 800189c0 <sb+0x18>
    800026ca:	9dbd                	addw	a1,a1,a5
    800026cc:	4108                	lw	a0,0(a0)
    800026ce:	95dff0ef          	jal	8000202a <bread>
    800026d2:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800026d4:	05850793          	addi	a5,a0,88
    800026d8:	40d8                	lw	a4,4(s1)
    800026da:	8b3d                	andi	a4,a4,15
    800026dc:	071a                	slli	a4,a4,0x6
    800026de:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800026e0:	04449703          	lh	a4,68(s1)
    800026e4:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800026e8:	04649703          	lh	a4,70(s1)
    800026ec:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800026f0:	04849703          	lh	a4,72(s1)
    800026f4:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800026f8:	04a49703          	lh	a4,74(s1)
    800026fc:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002700:	44f8                	lw	a4,76(s1)
    80002702:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002704:	03400613          	li	a2,52
    80002708:	05048593          	addi	a1,s1,80
    8000270c:	00c78513          	addi	a0,a5,12
    80002710:	ac3fd0ef          	jal	800001d2 <memmove>
  log_write(bp);
    80002714:	854a                	mv	a0,s2
    80002716:	267000ef          	jal	8000317c <log_write>
  brelse(bp);
    8000271a:	854a                	mv	a0,s2
    8000271c:	a17ff0ef          	jal	80002132 <brelse>
}
    80002720:	60e2                	ld	ra,24(sp)
    80002722:	6442                	ld	s0,16(sp)
    80002724:	64a2                	ld	s1,8(sp)
    80002726:	6902                	ld	s2,0(sp)
    80002728:	6105                	addi	sp,sp,32
    8000272a:	8082                	ret

000000008000272c <idup>:
{
    8000272c:	1101                	addi	sp,sp,-32
    8000272e:	ec06                	sd	ra,24(sp)
    80002730:	e822                	sd	s0,16(sp)
    80002732:	e426                	sd	s1,8(sp)
    80002734:	1000                	addi	s0,sp,32
    80002736:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002738:	00016517          	auipc	a0,0x16
    8000273c:	29050513          	addi	a0,a0,656 # 800189c8 <itable>
    80002740:	150030ef          	jal	80005890 <acquire>
  ip->ref++;
    80002744:	449c                	lw	a5,8(s1)
    80002746:	2785                	addiw	a5,a5,1
    80002748:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000274a:	00016517          	auipc	a0,0x16
    8000274e:	27e50513          	addi	a0,a0,638 # 800189c8 <itable>
    80002752:	1d6030ef          	jal	80005928 <release>
}
    80002756:	8526                	mv	a0,s1
    80002758:	60e2                	ld	ra,24(sp)
    8000275a:	6442                	ld	s0,16(sp)
    8000275c:	64a2                	ld	s1,8(sp)
    8000275e:	6105                	addi	sp,sp,32
    80002760:	8082                	ret

0000000080002762 <ilock>:
{
    80002762:	1101                	addi	sp,sp,-32
    80002764:	ec06                	sd	ra,24(sp)
    80002766:	e822                	sd	s0,16(sp)
    80002768:	e426                	sd	s1,8(sp)
    8000276a:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    8000276c:	cd19                	beqz	a0,8000278a <ilock+0x28>
    8000276e:	84aa                	mv	s1,a0
    80002770:	451c                	lw	a5,8(a0)
    80002772:	00f05c63          	blez	a5,8000278a <ilock+0x28>
  acquiresleep(&ip->lock);
    80002776:	0541                	addi	a0,a0,16
    80002778:	30b000ef          	jal	80003282 <acquiresleep>
  if(ip->valid == 0){
    8000277c:	40bc                	lw	a5,64(s1)
    8000277e:	cf89                	beqz	a5,80002798 <ilock+0x36>
}
    80002780:	60e2                	ld	ra,24(sp)
    80002782:	6442                	ld	s0,16(sp)
    80002784:	64a2                	ld	s1,8(sp)
    80002786:	6105                	addi	sp,sp,32
    80002788:	8082                	ret
    8000278a:	e04a                	sd	s2,0(sp)
    panic("ilock");
    8000278c:	00005517          	auipc	a0,0x5
    80002790:	ddc50513          	addi	a0,a0,-548 # 80007568 <etext+0x568>
    80002794:	5cf020ef          	jal	80005562 <panic>
    80002798:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000279a:	40dc                	lw	a5,4(s1)
    8000279c:	0047d79b          	srliw	a5,a5,0x4
    800027a0:	00016597          	auipc	a1,0x16
    800027a4:	2205a583          	lw	a1,544(a1) # 800189c0 <sb+0x18>
    800027a8:	9dbd                	addw	a1,a1,a5
    800027aa:	4088                	lw	a0,0(s1)
    800027ac:	87fff0ef          	jal	8000202a <bread>
    800027b0:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800027b2:	05850593          	addi	a1,a0,88
    800027b6:	40dc                	lw	a5,4(s1)
    800027b8:	8bbd                	andi	a5,a5,15
    800027ba:	079a                	slli	a5,a5,0x6
    800027bc:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800027be:	00059783          	lh	a5,0(a1)
    800027c2:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800027c6:	00259783          	lh	a5,2(a1)
    800027ca:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800027ce:	00459783          	lh	a5,4(a1)
    800027d2:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800027d6:	00659783          	lh	a5,6(a1)
    800027da:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800027de:	459c                	lw	a5,8(a1)
    800027e0:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800027e2:	03400613          	li	a2,52
    800027e6:	05b1                	addi	a1,a1,12
    800027e8:	05048513          	addi	a0,s1,80
    800027ec:	9e7fd0ef          	jal	800001d2 <memmove>
    brelse(bp);
    800027f0:	854a                	mv	a0,s2
    800027f2:	941ff0ef          	jal	80002132 <brelse>
    ip->valid = 1;
    800027f6:	4785                	li	a5,1
    800027f8:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800027fa:	04449783          	lh	a5,68(s1)
    800027fe:	c399                	beqz	a5,80002804 <ilock+0xa2>
    80002800:	6902                	ld	s2,0(sp)
    80002802:	bfbd                	j	80002780 <ilock+0x1e>
      panic("ilock: no type");
    80002804:	00005517          	auipc	a0,0x5
    80002808:	d6c50513          	addi	a0,a0,-660 # 80007570 <etext+0x570>
    8000280c:	557020ef          	jal	80005562 <panic>

0000000080002810 <iunlock>:
{
    80002810:	1101                	addi	sp,sp,-32
    80002812:	ec06                	sd	ra,24(sp)
    80002814:	e822                	sd	s0,16(sp)
    80002816:	e426                	sd	s1,8(sp)
    80002818:	e04a                	sd	s2,0(sp)
    8000281a:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    8000281c:	c505                	beqz	a0,80002844 <iunlock+0x34>
    8000281e:	84aa                	mv	s1,a0
    80002820:	01050913          	addi	s2,a0,16
    80002824:	854a                	mv	a0,s2
    80002826:	2db000ef          	jal	80003300 <holdingsleep>
    8000282a:	cd09                	beqz	a0,80002844 <iunlock+0x34>
    8000282c:	449c                	lw	a5,8(s1)
    8000282e:	00f05b63          	blez	a5,80002844 <iunlock+0x34>
  releasesleep(&ip->lock);
    80002832:	854a                	mv	a0,s2
    80002834:	295000ef          	jal	800032c8 <releasesleep>
}
    80002838:	60e2                	ld	ra,24(sp)
    8000283a:	6442                	ld	s0,16(sp)
    8000283c:	64a2                	ld	s1,8(sp)
    8000283e:	6902                	ld	s2,0(sp)
    80002840:	6105                	addi	sp,sp,32
    80002842:	8082                	ret
    panic("iunlock");
    80002844:	00005517          	auipc	a0,0x5
    80002848:	d3c50513          	addi	a0,a0,-708 # 80007580 <etext+0x580>
    8000284c:	517020ef          	jal	80005562 <panic>

0000000080002850 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002850:	7179                	addi	sp,sp,-48
    80002852:	f406                	sd	ra,40(sp)
    80002854:	f022                	sd	s0,32(sp)
    80002856:	ec26                	sd	s1,24(sp)
    80002858:	e84a                	sd	s2,16(sp)
    8000285a:	e44e                	sd	s3,8(sp)
    8000285c:	1800                	addi	s0,sp,48
    8000285e:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002860:	05050493          	addi	s1,a0,80
    80002864:	08050913          	addi	s2,a0,128
    80002868:	a021                	j	80002870 <itrunc+0x20>
    8000286a:	0491                	addi	s1,s1,4
    8000286c:	01248b63          	beq	s1,s2,80002882 <itrunc+0x32>
    if(ip->addrs[i]){
    80002870:	408c                	lw	a1,0(s1)
    80002872:	dde5                	beqz	a1,8000286a <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002874:	0009a503          	lw	a0,0(s3)
    80002878:	9abff0ef          	jal	80002222 <bfree>
      ip->addrs[i] = 0;
    8000287c:	0004a023          	sw	zero,0(s1)
    80002880:	b7ed                	j	8000286a <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002882:	0809a583          	lw	a1,128(s3)
    80002886:	ed89                	bnez	a1,800028a0 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002888:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    8000288c:	854e                	mv	a0,s3
    8000288e:	e21ff0ef          	jal	800026ae <iupdate>
}
    80002892:	70a2                	ld	ra,40(sp)
    80002894:	7402                	ld	s0,32(sp)
    80002896:	64e2                	ld	s1,24(sp)
    80002898:	6942                	ld	s2,16(sp)
    8000289a:	69a2                	ld	s3,8(sp)
    8000289c:	6145                	addi	sp,sp,48
    8000289e:	8082                	ret
    800028a0:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800028a2:	0009a503          	lw	a0,0(s3)
    800028a6:	f84ff0ef          	jal	8000202a <bread>
    800028aa:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    800028ac:	05850493          	addi	s1,a0,88
    800028b0:	45850913          	addi	s2,a0,1112
    800028b4:	a021                	j	800028bc <itrunc+0x6c>
    800028b6:	0491                	addi	s1,s1,4
    800028b8:	01248963          	beq	s1,s2,800028ca <itrunc+0x7a>
      if(a[j])
    800028bc:	408c                	lw	a1,0(s1)
    800028be:	dde5                	beqz	a1,800028b6 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    800028c0:	0009a503          	lw	a0,0(s3)
    800028c4:	95fff0ef          	jal	80002222 <bfree>
    800028c8:	b7fd                	j	800028b6 <itrunc+0x66>
    brelse(bp);
    800028ca:	8552                	mv	a0,s4
    800028cc:	867ff0ef          	jal	80002132 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800028d0:	0809a583          	lw	a1,128(s3)
    800028d4:	0009a503          	lw	a0,0(s3)
    800028d8:	94bff0ef          	jal	80002222 <bfree>
    ip->addrs[NDIRECT] = 0;
    800028dc:	0809a023          	sw	zero,128(s3)
    800028e0:	6a02                	ld	s4,0(sp)
    800028e2:	b75d                	j	80002888 <itrunc+0x38>

00000000800028e4 <iput>:
{
    800028e4:	1101                	addi	sp,sp,-32
    800028e6:	ec06                	sd	ra,24(sp)
    800028e8:	e822                	sd	s0,16(sp)
    800028ea:	e426                	sd	s1,8(sp)
    800028ec:	1000                	addi	s0,sp,32
    800028ee:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800028f0:	00016517          	auipc	a0,0x16
    800028f4:	0d850513          	addi	a0,a0,216 # 800189c8 <itable>
    800028f8:	799020ef          	jal	80005890 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800028fc:	4498                	lw	a4,8(s1)
    800028fe:	4785                	li	a5,1
    80002900:	02f70063          	beq	a4,a5,80002920 <iput+0x3c>
  ip->ref--;
    80002904:	449c                	lw	a5,8(s1)
    80002906:	37fd                	addiw	a5,a5,-1
    80002908:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000290a:	00016517          	auipc	a0,0x16
    8000290e:	0be50513          	addi	a0,a0,190 # 800189c8 <itable>
    80002912:	016030ef          	jal	80005928 <release>
}
    80002916:	60e2                	ld	ra,24(sp)
    80002918:	6442                	ld	s0,16(sp)
    8000291a:	64a2                	ld	s1,8(sp)
    8000291c:	6105                	addi	sp,sp,32
    8000291e:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002920:	40bc                	lw	a5,64(s1)
    80002922:	d3ed                	beqz	a5,80002904 <iput+0x20>
    80002924:	04a49783          	lh	a5,74(s1)
    80002928:	fff1                	bnez	a5,80002904 <iput+0x20>
    8000292a:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    8000292c:	01048913          	addi	s2,s1,16
    80002930:	854a                	mv	a0,s2
    80002932:	151000ef          	jal	80003282 <acquiresleep>
    release(&itable.lock);
    80002936:	00016517          	auipc	a0,0x16
    8000293a:	09250513          	addi	a0,a0,146 # 800189c8 <itable>
    8000293e:	7eb020ef          	jal	80005928 <release>
    itrunc(ip);
    80002942:	8526                	mv	a0,s1
    80002944:	f0dff0ef          	jal	80002850 <itrunc>
    ip->type = 0;
    80002948:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    8000294c:	8526                	mv	a0,s1
    8000294e:	d61ff0ef          	jal	800026ae <iupdate>
    ip->valid = 0;
    80002952:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002956:	854a                	mv	a0,s2
    80002958:	171000ef          	jal	800032c8 <releasesleep>
    acquire(&itable.lock);
    8000295c:	00016517          	auipc	a0,0x16
    80002960:	06c50513          	addi	a0,a0,108 # 800189c8 <itable>
    80002964:	72d020ef          	jal	80005890 <acquire>
    80002968:	6902                	ld	s2,0(sp)
    8000296a:	bf69                	j	80002904 <iput+0x20>

000000008000296c <iunlockput>:
{
    8000296c:	1101                	addi	sp,sp,-32
    8000296e:	ec06                	sd	ra,24(sp)
    80002970:	e822                	sd	s0,16(sp)
    80002972:	e426                	sd	s1,8(sp)
    80002974:	1000                	addi	s0,sp,32
    80002976:	84aa                	mv	s1,a0
  iunlock(ip);
    80002978:	e99ff0ef          	jal	80002810 <iunlock>
  iput(ip);
    8000297c:	8526                	mv	a0,s1
    8000297e:	f67ff0ef          	jal	800028e4 <iput>
}
    80002982:	60e2                	ld	ra,24(sp)
    80002984:	6442                	ld	s0,16(sp)
    80002986:	64a2                	ld	s1,8(sp)
    80002988:	6105                	addi	sp,sp,32
    8000298a:	8082                	ret

000000008000298c <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    8000298c:	1141                	addi	sp,sp,-16
    8000298e:	e422                	sd	s0,8(sp)
    80002990:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002992:	411c                	lw	a5,0(a0)
    80002994:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002996:	415c                	lw	a5,4(a0)
    80002998:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    8000299a:	04451783          	lh	a5,68(a0)
    8000299e:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800029a2:	04a51783          	lh	a5,74(a0)
    800029a6:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800029aa:	04c56783          	lwu	a5,76(a0)
    800029ae:	e99c                	sd	a5,16(a1)
}
    800029b0:	6422                	ld	s0,8(sp)
    800029b2:	0141                	addi	sp,sp,16
    800029b4:	8082                	ret

00000000800029b6 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800029b6:	457c                	lw	a5,76(a0)
    800029b8:	0ed7eb63          	bltu	a5,a3,80002aae <readi+0xf8>
{
    800029bc:	7159                	addi	sp,sp,-112
    800029be:	f486                	sd	ra,104(sp)
    800029c0:	f0a2                	sd	s0,96(sp)
    800029c2:	eca6                	sd	s1,88(sp)
    800029c4:	e0d2                	sd	s4,64(sp)
    800029c6:	fc56                	sd	s5,56(sp)
    800029c8:	f85a                	sd	s6,48(sp)
    800029ca:	f45e                	sd	s7,40(sp)
    800029cc:	1880                	addi	s0,sp,112
    800029ce:	8b2a                	mv	s6,a0
    800029d0:	8bae                	mv	s7,a1
    800029d2:	8a32                	mv	s4,a2
    800029d4:	84b6                	mv	s1,a3
    800029d6:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    800029d8:	9f35                	addw	a4,a4,a3
    return 0;
    800029da:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800029dc:	0cd76063          	bltu	a4,a3,80002a9c <readi+0xe6>
    800029e0:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    800029e2:	00e7f463          	bgeu	a5,a4,800029ea <readi+0x34>
    n = ip->size - off;
    800029e6:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800029ea:	080a8f63          	beqz	s5,80002a88 <readi+0xd2>
    800029ee:	e8ca                	sd	s2,80(sp)
    800029f0:	f062                	sd	s8,32(sp)
    800029f2:	ec66                	sd	s9,24(sp)
    800029f4:	e86a                	sd	s10,16(sp)
    800029f6:	e46e                	sd	s11,8(sp)
    800029f8:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800029fa:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800029fe:	5c7d                	li	s8,-1
    80002a00:	a80d                	j	80002a32 <readi+0x7c>
    80002a02:	020d1d93          	slli	s11,s10,0x20
    80002a06:	020ddd93          	srli	s11,s11,0x20
    80002a0a:	05890613          	addi	a2,s2,88
    80002a0e:	86ee                	mv	a3,s11
    80002a10:	963a                	add	a2,a2,a4
    80002a12:	85d2                	mv	a1,s4
    80002a14:	855e                	mv	a0,s7
    80002a16:	cadfe0ef          	jal	800016c2 <either_copyout>
    80002a1a:	05850763          	beq	a0,s8,80002a68 <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002a1e:	854a                	mv	a0,s2
    80002a20:	f12ff0ef          	jal	80002132 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002a24:	013d09bb          	addw	s3,s10,s3
    80002a28:	009d04bb          	addw	s1,s10,s1
    80002a2c:	9a6e                	add	s4,s4,s11
    80002a2e:	0559f763          	bgeu	s3,s5,80002a7c <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    80002a32:	00a4d59b          	srliw	a1,s1,0xa
    80002a36:	855a                	mv	a0,s6
    80002a38:	977ff0ef          	jal	800023ae <bmap>
    80002a3c:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002a40:	c5b1                	beqz	a1,80002a8c <readi+0xd6>
    bp = bread(ip->dev, addr);
    80002a42:	000b2503          	lw	a0,0(s6)
    80002a46:	de4ff0ef          	jal	8000202a <bread>
    80002a4a:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002a4c:	3ff4f713          	andi	a4,s1,1023
    80002a50:	40ec87bb          	subw	a5,s9,a4
    80002a54:	413a86bb          	subw	a3,s5,s3
    80002a58:	8d3e                	mv	s10,a5
    80002a5a:	2781                	sext.w	a5,a5
    80002a5c:	0006861b          	sext.w	a2,a3
    80002a60:	faf671e3          	bgeu	a2,a5,80002a02 <readi+0x4c>
    80002a64:	8d36                	mv	s10,a3
    80002a66:	bf71                	j	80002a02 <readi+0x4c>
      brelse(bp);
    80002a68:	854a                	mv	a0,s2
    80002a6a:	ec8ff0ef          	jal	80002132 <brelse>
      tot = -1;
    80002a6e:	59fd                	li	s3,-1
      break;
    80002a70:	6946                	ld	s2,80(sp)
    80002a72:	7c02                	ld	s8,32(sp)
    80002a74:	6ce2                	ld	s9,24(sp)
    80002a76:	6d42                	ld	s10,16(sp)
    80002a78:	6da2                	ld	s11,8(sp)
    80002a7a:	a831                	j	80002a96 <readi+0xe0>
    80002a7c:	6946                	ld	s2,80(sp)
    80002a7e:	7c02                	ld	s8,32(sp)
    80002a80:	6ce2                	ld	s9,24(sp)
    80002a82:	6d42                	ld	s10,16(sp)
    80002a84:	6da2                	ld	s11,8(sp)
    80002a86:	a801                	j	80002a96 <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002a88:	89d6                	mv	s3,s5
    80002a8a:	a031                	j	80002a96 <readi+0xe0>
    80002a8c:	6946                	ld	s2,80(sp)
    80002a8e:	7c02                	ld	s8,32(sp)
    80002a90:	6ce2                	ld	s9,24(sp)
    80002a92:	6d42                	ld	s10,16(sp)
    80002a94:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002a96:	0009851b          	sext.w	a0,s3
    80002a9a:	69a6                	ld	s3,72(sp)
}
    80002a9c:	70a6                	ld	ra,104(sp)
    80002a9e:	7406                	ld	s0,96(sp)
    80002aa0:	64e6                	ld	s1,88(sp)
    80002aa2:	6a06                	ld	s4,64(sp)
    80002aa4:	7ae2                	ld	s5,56(sp)
    80002aa6:	7b42                	ld	s6,48(sp)
    80002aa8:	7ba2                	ld	s7,40(sp)
    80002aaa:	6165                	addi	sp,sp,112
    80002aac:	8082                	ret
    return 0;
    80002aae:	4501                	li	a0,0
}
    80002ab0:	8082                	ret

0000000080002ab2 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002ab2:	457c                	lw	a5,76(a0)
    80002ab4:	10d7e063          	bltu	a5,a3,80002bb4 <writei+0x102>
{
    80002ab8:	7159                	addi	sp,sp,-112
    80002aba:	f486                	sd	ra,104(sp)
    80002abc:	f0a2                	sd	s0,96(sp)
    80002abe:	e8ca                	sd	s2,80(sp)
    80002ac0:	e0d2                	sd	s4,64(sp)
    80002ac2:	fc56                	sd	s5,56(sp)
    80002ac4:	f85a                	sd	s6,48(sp)
    80002ac6:	f45e                	sd	s7,40(sp)
    80002ac8:	1880                	addi	s0,sp,112
    80002aca:	8aaa                	mv	s5,a0
    80002acc:	8bae                	mv	s7,a1
    80002ace:	8a32                	mv	s4,a2
    80002ad0:	8936                	mv	s2,a3
    80002ad2:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002ad4:	00e687bb          	addw	a5,a3,a4
    80002ad8:	0ed7e063          	bltu	a5,a3,80002bb8 <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002adc:	00043737          	lui	a4,0x43
    80002ae0:	0cf76e63          	bltu	a4,a5,80002bbc <writei+0x10a>
    80002ae4:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002ae6:	0a0b0f63          	beqz	s6,80002ba4 <writei+0xf2>
    80002aea:	eca6                	sd	s1,88(sp)
    80002aec:	f062                	sd	s8,32(sp)
    80002aee:	ec66                	sd	s9,24(sp)
    80002af0:	e86a                	sd	s10,16(sp)
    80002af2:	e46e                	sd	s11,8(sp)
    80002af4:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002af6:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002afa:	5c7d                	li	s8,-1
    80002afc:	a825                	j	80002b34 <writei+0x82>
    80002afe:	020d1d93          	slli	s11,s10,0x20
    80002b02:	020ddd93          	srli	s11,s11,0x20
    80002b06:	05848513          	addi	a0,s1,88
    80002b0a:	86ee                	mv	a3,s11
    80002b0c:	8652                	mv	a2,s4
    80002b0e:	85de                	mv	a1,s7
    80002b10:	953a                	add	a0,a0,a4
    80002b12:	bfbfe0ef          	jal	8000170c <either_copyin>
    80002b16:	05850a63          	beq	a0,s8,80002b6a <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002b1a:	8526                	mv	a0,s1
    80002b1c:	660000ef          	jal	8000317c <log_write>
    brelse(bp);
    80002b20:	8526                	mv	a0,s1
    80002b22:	e10ff0ef          	jal	80002132 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002b26:	013d09bb          	addw	s3,s10,s3
    80002b2a:	012d093b          	addw	s2,s10,s2
    80002b2e:	9a6e                	add	s4,s4,s11
    80002b30:	0569f063          	bgeu	s3,s6,80002b70 <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80002b34:	00a9559b          	srliw	a1,s2,0xa
    80002b38:	8556                	mv	a0,s5
    80002b3a:	875ff0ef          	jal	800023ae <bmap>
    80002b3e:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002b42:	c59d                	beqz	a1,80002b70 <writei+0xbe>
    bp = bread(ip->dev, addr);
    80002b44:	000aa503          	lw	a0,0(s5)
    80002b48:	ce2ff0ef          	jal	8000202a <bread>
    80002b4c:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002b4e:	3ff97713          	andi	a4,s2,1023
    80002b52:	40ec87bb          	subw	a5,s9,a4
    80002b56:	413b06bb          	subw	a3,s6,s3
    80002b5a:	8d3e                	mv	s10,a5
    80002b5c:	2781                	sext.w	a5,a5
    80002b5e:	0006861b          	sext.w	a2,a3
    80002b62:	f8f67ee3          	bgeu	a2,a5,80002afe <writei+0x4c>
    80002b66:	8d36                	mv	s10,a3
    80002b68:	bf59                	j	80002afe <writei+0x4c>
      brelse(bp);
    80002b6a:	8526                	mv	a0,s1
    80002b6c:	dc6ff0ef          	jal	80002132 <brelse>
  }

  if(off > ip->size)
    80002b70:	04caa783          	lw	a5,76(s5)
    80002b74:	0327fa63          	bgeu	a5,s2,80002ba8 <writei+0xf6>
    ip->size = off;
    80002b78:	052aa623          	sw	s2,76(s5)
    80002b7c:	64e6                	ld	s1,88(sp)
    80002b7e:	7c02                	ld	s8,32(sp)
    80002b80:	6ce2                	ld	s9,24(sp)
    80002b82:	6d42                	ld	s10,16(sp)
    80002b84:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002b86:	8556                	mv	a0,s5
    80002b88:	b27ff0ef          	jal	800026ae <iupdate>

  return tot;
    80002b8c:	0009851b          	sext.w	a0,s3
    80002b90:	69a6                	ld	s3,72(sp)
}
    80002b92:	70a6                	ld	ra,104(sp)
    80002b94:	7406                	ld	s0,96(sp)
    80002b96:	6946                	ld	s2,80(sp)
    80002b98:	6a06                	ld	s4,64(sp)
    80002b9a:	7ae2                	ld	s5,56(sp)
    80002b9c:	7b42                	ld	s6,48(sp)
    80002b9e:	7ba2                	ld	s7,40(sp)
    80002ba0:	6165                	addi	sp,sp,112
    80002ba2:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002ba4:	89da                	mv	s3,s6
    80002ba6:	b7c5                	j	80002b86 <writei+0xd4>
    80002ba8:	64e6                	ld	s1,88(sp)
    80002baa:	7c02                	ld	s8,32(sp)
    80002bac:	6ce2                	ld	s9,24(sp)
    80002bae:	6d42                	ld	s10,16(sp)
    80002bb0:	6da2                	ld	s11,8(sp)
    80002bb2:	bfd1                	j	80002b86 <writei+0xd4>
    return -1;
    80002bb4:	557d                	li	a0,-1
}
    80002bb6:	8082                	ret
    return -1;
    80002bb8:	557d                	li	a0,-1
    80002bba:	bfe1                	j	80002b92 <writei+0xe0>
    return -1;
    80002bbc:	557d                	li	a0,-1
    80002bbe:	bfd1                	j	80002b92 <writei+0xe0>

0000000080002bc0 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002bc0:	1141                	addi	sp,sp,-16
    80002bc2:	e406                	sd	ra,8(sp)
    80002bc4:	e022                	sd	s0,0(sp)
    80002bc6:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002bc8:	4639                	li	a2,14
    80002bca:	e78fd0ef          	jal	80000242 <strncmp>
}
    80002bce:	60a2                	ld	ra,8(sp)
    80002bd0:	6402                	ld	s0,0(sp)
    80002bd2:	0141                	addi	sp,sp,16
    80002bd4:	8082                	ret

0000000080002bd6 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002bd6:	7139                	addi	sp,sp,-64
    80002bd8:	fc06                	sd	ra,56(sp)
    80002bda:	f822                	sd	s0,48(sp)
    80002bdc:	f426                	sd	s1,40(sp)
    80002bde:	f04a                	sd	s2,32(sp)
    80002be0:	ec4e                	sd	s3,24(sp)
    80002be2:	e852                	sd	s4,16(sp)
    80002be4:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002be6:	04451703          	lh	a4,68(a0)
    80002bea:	4785                	li	a5,1
    80002bec:	00f71a63          	bne	a4,a5,80002c00 <dirlookup+0x2a>
    80002bf0:	892a                	mv	s2,a0
    80002bf2:	89ae                	mv	s3,a1
    80002bf4:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002bf6:	457c                	lw	a5,76(a0)
    80002bf8:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002bfa:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002bfc:	e39d                	bnez	a5,80002c22 <dirlookup+0x4c>
    80002bfe:	a095                	j	80002c62 <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80002c00:	00005517          	auipc	a0,0x5
    80002c04:	98850513          	addi	a0,a0,-1656 # 80007588 <etext+0x588>
    80002c08:	15b020ef          	jal	80005562 <panic>
      panic("dirlookup read");
    80002c0c:	00005517          	auipc	a0,0x5
    80002c10:	99450513          	addi	a0,a0,-1644 # 800075a0 <etext+0x5a0>
    80002c14:	14f020ef          	jal	80005562 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002c18:	24c1                	addiw	s1,s1,16
    80002c1a:	04c92783          	lw	a5,76(s2)
    80002c1e:	04f4f163          	bgeu	s1,a5,80002c60 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002c22:	4741                	li	a4,16
    80002c24:	86a6                	mv	a3,s1
    80002c26:	fc040613          	addi	a2,s0,-64
    80002c2a:	4581                	li	a1,0
    80002c2c:	854a                	mv	a0,s2
    80002c2e:	d89ff0ef          	jal	800029b6 <readi>
    80002c32:	47c1                	li	a5,16
    80002c34:	fcf51ce3          	bne	a0,a5,80002c0c <dirlookup+0x36>
    if(de.inum == 0)
    80002c38:	fc045783          	lhu	a5,-64(s0)
    80002c3c:	dff1                	beqz	a5,80002c18 <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80002c3e:	fc240593          	addi	a1,s0,-62
    80002c42:	854e                	mv	a0,s3
    80002c44:	f7dff0ef          	jal	80002bc0 <namecmp>
    80002c48:	f961                	bnez	a0,80002c18 <dirlookup+0x42>
      if(poff)
    80002c4a:	000a0463          	beqz	s4,80002c52 <dirlookup+0x7c>
        *poff = off;
    80002c4e:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80002c52:	fc045583          	lhu	a1,-64(s0)
    80002c56:	00092503          	lw	a0,0(s2)
    80002c5a:	829ff0ef          	jal	80002482 <iget>
    80002c5e:	a011                	j	80002c62 <dirlookup+0x8c>
  return 0;
    80002c60:	4501                	li	a0,0
}
    80002c62:	70e2                	ld	ra,56(sp)
    80002c64:	7442                	ld	s0,48(sp)
    80002c66:	74a2                	ld	s1,40(sp)
    80002c68:	7902                	ld	s2,32(sp)
    80002c6a:	69e2                	ld	s3,24(sp)
    80002c6c:	6a42                	ld	s4,16(sp)
    80002c6e:	6121                	addi	sp,sp,64
    80002c70:	8082                	ret

0000000080002c72 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002c72:	711d                	addi	sp,sp,-96
    80002c74:	ec86                	sd	ra,88(sp)
    80002c76:	e8a2                	sd	s0,80(sp)
    80002c78:	e4a6                	sd	s1,72(sp)
    80002c7a:	e0ca                	sd	s2,64(sp)
    80002c7c:	fc4e                	sd	s3,56(sp)
    80002c7e:	f852                	sd	s4,48(sp)
    80002c80:	f456                	sd	s5,40(sp)
    80002c82:	f05a                	sd	s6,32(sp)
    80002c84:	ec5e                	sd	s7,24(sp)
    80002c86:	e862                	sd	s8,16(sp)
    80002c88:	e466                	sd	s9,8(sp)
    80002c8a:	1080                	addi	s0,sp,96
    80002c8c:	84aa                	mv	s1,a0
    80002c8e:	8b2e                	mv	s6,a1
    80002c90:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002c92:	00054703          	lbu	a4,0(a0)
    80002c96:	02f00793          	li	a5,47
    80002c9a:	00f70e63          	beq	a4,a5,80002cb6 <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002c9e:	8fafe0ef          	jal	80000d98 <myproc>
    80002ca2:	15053503          	ld	a0,336(a0)
    80002ca6:	a87ff0ef          	jal	8000272c <idup>
    80002caa:	8a2a                	mv	s4,a0
  while(*path == '/')
    80002cac:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80002cb0:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002cb2:	4b85                	li	s7,1
    80002cb4:	a871                	j	80002d50 <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    80002cb6:	4585                	li	a1,1
    80002cb8:	4505                	li	a0,1
    80002cba:	fc8ff0ef          	jal	80002482 <iget>
    80002cbe:	8a2a                	mv	s4,a0
    80002cc0:	b7f5                	j	80002cac <namex+0x3a>
      iunlockput(ip);
    80002cc2:	8552                	mv	a0,s4
    80002cc4:	ca9ff0ef          	jal	8000296c <iunlockput>
      return 0;
    80002cc8:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002cca:	8552                	mv	a0,s4
    80002ccc:	60e6                	ld	ra,88(sp)
    80002cce:	6446                	ld	s0,80(sp)
    80002cd0:	64a6                	ld	s1,72(sp)
    80002cd2:	6906                	ld	s2,64(sp)
    80002cd4:	79e2                	ld	s3,56(sp)
    80002cd6:	7a42                	ld	s4,48(sp)
    80002cd8:	7aa2                	ld	s5,40(sp)
    80002cda:	7b02                	ld	s6,32(sp)
    80002cdc:	6be2                	ld	s7,24(sp)
    80002cde:	6c42                	ld	s8,16(sp)
    80002ce0:	6ca2                	ld	s9,8(sp)
    80002ce2:	6125                	addi	sp,sp,96
    80002ce4:	8082                	ret
      iunlock(ip);
    80002ce6:	8552                	mv	a0,s4
    80002ce8:	b29ff0ef          	jal	80002810 <iunlock>
      return ip;
    80002cec:	bff9                	j	80002cca <namex+0x58>
      iunlockput(ip);
    80002cee:	8552                	mv	a0,s4
    80002cf0:	c7dff0ef          	jal	8000296c <iunlockput>
      return 0;
    80002cf4:	8a4e                	mv	s4,s3
    80002cf6:	bfd1                	j	80002cca <namex+0x58>
  len = path - s;
    80002cf8:	40998633          	sub	a2,s3,s1
    80002cfc:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80002d00:	099c5063          	bge	s8,s9,80002d80 <namex+0x10e>
    memmove(name, s, DIRSIZ);
    80002d04:	4639                	li	a2,14
    80002d06:	85a6                	mv	a1,s1
    80002d08:	8556                	mv	a0,s5
    80002d0a:	cc8fd0ef          	jal	800001d2 <memmove>
    80002d0e:	84ce                	mv	s1,s3
  while(*path == '/')
    80002d10:	0004c783          	lbu	a5,0(s1)
    80002d14:	01279763          	bne	a5,s2,80002d22 <namex+0xb0>
    path++;
    80002d18:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002d1a:	0004c783          	lbu	a5,0(s1)
    80002d1e:	ff278de3          	beq	a5,s2,80002d18 <namex+0xa6>
    ilock(ip);
    80002d22:	8552                	mv	a0,s4
    80002d24:	a3fff0ef          	jal	80002762 <ilock>
    if(ip->type != T_DIR){
    80002d28:	044a1783          	lh	a5,68(s4)
    80002d2c:	f9779be3          	bne	a5,s7,80002cc2 <namex+0x50>
    if(nameiparent && *path == '\0'){
    80002d30:	000b0563          	beqz	s6,80002d3a <namex+0xc8>
    80002d34:	0004c783          	lbu	a5,0(s1)
    80002d38:	d7dd                	beqz	a5,80002ce6 <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    80002d3a:	4601                	li	a2,0
    80002d3c:	85d6                	mv	a1,s5
    80002d3e:	8552                	mv	a0,s4
    80002d40:	e97ff0ef          	jal	80002bd6 <dirlookup>
    80002d44:	89aa                	mv	s3,a0
    80002d46:	d545                	beqz	a0,80002cee <namex+0x7c>
    iunlockput(ip);
    80002d48:	8552                	mv	a0,s4
    80002d4a:	c23ff0ef          	jal	8000296c <iunlockput>
    ip = next;
    80002d4e:	8a4e                	mv	s4,s3
  while(*path == '/')
    80002d50:	0004c783          	lbu	a5,0(s1)
    80002d54:	01279763          	bne	a5,s2,80002d62 <namex+0xf0>
    path++;
    80002d58:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002d5a:	0004c783          	lbu	a5,0(s1)
    80002d5e:	ff278de3          	beq	a5,s2,80002d58 <namex+0xe6>
  if(*path == 0)
    80002d62:	cb8d                	beqz	a5,80002d94 <namex+0x122>
  while(*path != '/' && *path != 0)
    80002d64:	0004c783          	lbu	a5,0(s1)
    80002d68:	89a6                	mv	s3,s1
  len = path - s;
    80002d6a:	4c81                	li	s9,0
    80002d6c:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80002d6e:	01278963          	beq	a5,s2,80002d80 <namex+0x10e>
    80002d72:	d3d9                	beqz	a5,80002cf8 <namex+0x86>
    path++;
    80002d74:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80002d76:	0009c783          	lbu	a5,0(s3)
    80002d7a:	ff279ce3          	bne	a5,s2,80002d72 <namex+0x100>
    80002d7e:	bfad                	j	80002cf8 <namex+0x86>
    memmove(name, s, len);
    80002d80:	2601                	sext.w	a2,a2
    80002d82:	85a6                	mv	a1,s1
    80002d84:	8556                	mv	a0,s5
    80002d86:	c4cfd0ef          	jal	800001d2 <memmove>
    name[len] = 0;
    80002d8a:	9cd6                	add	s9,s9,s5
    80002d8c:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80002d90:	84ce                	mv	s1,s3
    80002d92:	bfbd                	j	80002d10 <namex+0x9e>
  if(nameiparent){
    80002d94:	f20b0be3          	beqz	s6,80002cca <namex+0x58>
    iput(ip);
    80002d98:	8552                	mv	a0,s4
    80002d9a:	b4bff0ef          	jal	800028e4 <iput>
    return 0;
    80002d9e:	4a01                	li	s4,0
    80002da0:	b72d                	j	80002cca <namex+0x58>

0000000080002da2 <dirlink>:
{
    80002da2:	7139                	addi	sp,sp,-64
    80002da4:	fc06                	sd	ra,56(sp)
    80002da6:	f822                	sd	s0,48(sp)
    80002da8:	f04a                	sd	s2,32(sp)
    80002daa:	ec4e                	sd	s3,24(sp)
    80002dac:	e852                	sd	s4,16(sp)
    80002dae:	0080                	addi	s0,sp,64
    80002db0:	892a                	mv	s2,a0
    80002db2:	8a2e                	mv	s4,a1
    80002db4:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80002db6:	4601                	li	a2,0
    80002db8:	e1fff0ef          	jal	80002bd6 <dirlookup>
    80002dbc:	e535                	bnez	a0,80002e28 <dirlink+0x86>
    80002dbe:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002dc0:	04c92483          	lw	s1,76(s2)
    80002dc4:	c48d                	beqz	s1,80002dee <dirlink+0x4c>
    80002dc6:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002dc8:	4741                	li	a4,16
    80002dca:	86a6                	mv	a3,s1
    80002dcc:	fc040613          	addi	a2,s0,-64
    80002dd0:	4581                	li	a1,0
    80002dd2:	854a                	mv	a0,s2
    80002dd4:	be3ff0ef          	jal	800029b6 <readi>
    80002dd8:	47c1                	li	a5,16
    80002dda:	04f51b63          	bne	a0,a5,80002e30 <dirlink+0x8e>
    if(de.inum == 0)
    80002dde:	fc045783          	lhu	a5,-64(s0)
    80002de2:	c791                	beqz	a5,80002dee <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002de4:	24c1                	addiw	s1,s1,16
    80002de6:	04c92783          	lw	a5,76(s2)
    80002dea:	fcf4efe3          	bltu	s1,a5,80002dc8 <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80002dee:	4639                	li	a2,14
    80002df0:	85d2                	mv	a1,s4
    80002df2:	fc240513          	addi	a0,s0,-62
    80002df6:	c82fd0ef          	jal	80000278 <strncpy>
  de.inum = inum;
    80002dfa:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002dfe:	4741                	li	a4,16
    80002e00:	86a6                	mv	a3,s1
    80002e02:	fc040613          	addi	a2,s0,-64
    80002e06:	4581                	li	a1,0
    80002e08:	854a                	mv	a0,s2
    80002e0a:	ca9ff0ef          	jal	80002ab2 <writei>
    80002e0e:	1541                	addi	a0,a0,-16
    80002e10:	00a03533          	snez	a0,a0
    80002e14:	40a00533          	neg	a0,a0
    80002e18:	74a2                	ld	s1,40(sp)
}
    80002e1a:	70e2                	ld	ra,56(sp)
    80002e1c:	7442                	ld	s0,48(sp)
    80002e1e:	7902                	ld	s2,32(sp)
    80002e20:	69e2                	ld	s3,24(sp)
    80002e22:	6a42                	ld	s4,16(sp)
    80002e24:	6121                	addi	sp,sp,64
    80002e26:	8082                	ret
    iput(ip);
    80002e28:	abdff0ef          	jal	800028e4 <iput>
    return -1;
    80002e2c:	557d                	li	a0,-1
    80002e2e:	b7f5                	j	80002e1a <dirlink+0x78>
      panic("dirlink read");
    80002e30:	00004517          	auipc	a0,0x4
    80002e34:	78050513          	addi	a0,a0,1920 # 800075b0 <etext+0x5b0>
    80002e38:	72a020ef          	jal	80005562 <panic>

0000000080002e3c <namei>:

struct inode*
namei(char *path)
{
    80002e3c:	1101                	addi	sp,sp,-32
    80002e3e:	ec06                	sd	ra,24(sp)
    80002e40:	e822                	sd	s0,16(sp)
    80002e42:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80002e44:	fe040613          	addi	a2,s0,-32
    80002e48:	4581                	li	a1,0
    80002e4a:	e29ff0ef          	jal	80002c72 <namex>
}
    80002e4e:	60e2                	ld	ra,24(sp)
    80002e50:	6442                	ld	s0,16(sp)
    80002e52:	6105                	addi	sp,sp,32
    80002e54:	8082                	ret

0000000080002e56 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80002e56:	1141                	addi	sp,sp,-16
    80002e58:	e406                	sd	ra,8(sp)
    80002e5a:	e022                	sd	s0,0(sp)
    80002e5c:	0800                	addi	s0,sp,16
    80002e5e:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80002e60:	4585                	li	a1,1
    80002e62:	e11ff0ef          	jal	80002c72 <namex>
}
    80002e66:	60a2                	ld	ra,8(sp)
    80002e68:	6402                	ld	s0,0(sp)
    80002e6a:	0141                	addi	sp,sp,16
    80002e6c:	8082                	ret

0000000080002e6e <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80002e6e:	1101                	addi	sp,sp,-32
    80002e70:	ec06                	sd	ra,24(sp)
    80002e72:	e822                	sd	s0,16(sp)
    80002e74:	e426                	sd	s1,8(sp)
    80002e76:	e04a                	sd	s2,0(sp)
    80002e78:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80002e7a:	00017917          	auipc	s2,0x17
    80002e7e:	5f690913          	addi	s2,s2,1526 # 8001a470 <log>
    80002e82:	01892583          	lw	a1,24(s2)
    80002e86:	02892503          	lw	a0,40(s2)
    80002e8a:	9a0ff0ef          	jal	8000202a <bread>
    80002e8e:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80002e90:	02c92603          	lw	a2,44(s2)
    80002e94:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80002e96:	00c05f63          	blez	a2,80002eb4 <write_head+0x46>
    80002e9a:	00017717          	auipc	a4,0x17
    80002e9e:	60670713          	addi	a4,a4,1542 # 8001a4a0 <log+0x30>
    80002ea2:	87aa                	mv	a5,a0
    80002ea4:	060a                	slli	a2,a2,0x2
    80002ea6:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80002ea8:	4314                	lw	a3,0(a4)
    80002eaa:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80002eac:	0711                	addi	a4,a4,4
    80002eae:	0791                	addi	a5,a5,4
    80002eb0:	fec79ce3          	bne	a5,a2,80002ea8 <write_head+0x3a>
  }
  bwrite(buf);
    80002eb4:	8526                	mv	a0,s1
    80002eb6:	a4aff0ef          	jal	80002100 <bwrite>
  brelse(buf);
    80002eba:	8526                	mv	a0,s1
    80002ebc:	a76ff0ef          	jal	80002132 <brelse>
}
    80002ec0:	60e2                	ld	ra,24(sp)
    80002ec2:	6442                	ld	s0,16(sp)
    80002ec4:	64a2                	ld	s1,8(sp)
    80002ec6:	6902                	ld	s2,0(sp)
    80002ec8:	6105                	addi	sp,sp,32
    80002eca:	8082                	ret

0000000080002ecc <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80002ecc:	00017797          	auipc	a5,0x17
    80002ed0:	5d07a783          	lw	a5,1488(a5) # 8001a49c <log+0x2c>
    80002ed4:	08f05f63          	blez	a5,80002f72 <install_trans+0xa6>
{
    80002ed8:	7139                	addi	sp,sp,-64
    80002eda:	fc06                	sd	ra,56(sp)
    80002edc:	f822                	sd	s0,48(sp)
    80002ede:	f426                	sd	s1,40(sp)
    80002ee0:	f04a                	sd	s2,32(sp)
    80002ee2:	ec4e                	sd	s3,24(sp)
    80002ee4:	e852                	sd	s4,16(sp)
    80002ee6:	e456                	sd	s5,8(sp)
    80002ee8:	e05a                	sd	s6,0(sp)
    80002eea:	0080                	addi	s0,sp,64
    80002eec:	8b2a                	mv	s6,a0
    80002eee:	00017a97          	auipc	s5,0x17
    80002ef2:	5b2a8a93          	addi	s5,s5,1458 # 8001a4a0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002ef6:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002ef8:	00017997          	auipc	s3,0x17
    80002efc:	57898993          	addi	s3,s3,1400 # 8001a470 <log>
    80002f00:	a829                	j	80002f1a <install_trans+0x4e>
    brelse(lbuf);
    80002f02:	854a                	mv	a0,s2
    80002f04:	a2eff0ef          	jal	80002132 <brelse>
    brelse(dbuf);
    80002f08:	8526                	mv	a0,s1
    80002f0a:	a28ff0ef          	jal	80002132 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002f0e:	2a05                	addiw	s4,s4,1
    80002f10:	0a91                	addi	s5,s5,4
    80002f12:	02c9a783          	lw	a5,44(s3)
    80002f16:	04fa5463          	bge	s4,a5,80002f5e <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002f1a:	0189a583          	lw	a1,24(s3)
    80002f1e:	014585bb          	addw	a1,a1,s4
    80002f22:	2585                	addiw	a1,a1,1
    80002f24:	0289a503          	lw	a0,40(s3)
    80002f28:	902ff0ef          	jal	8000202a <bread>
    80002f2c:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80002f2e:	000aa583          	lw	a1,0(s5)
    80002f32:	0289a503          	lw	a0,40(s3)
    80002f36:	8f4ff0ef          	jal	8000202a <bread>
    80002f3a:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80002f3c:	40000613          	li	a2,1024
    80002f40:	05890593          	addi	a1,s2,88
    80002f44:	05850513          	addi	a0,a0,88
    80002f48:	a8afd0ef          	jal	800001d2 <memmove>
    bwrite(dbuf);  // write dst to disk
    80002f4c:	8526                	mv	a0,s1
    80002f4e:	9b2ff0ef          	jal	80002100 <bwrite>
    if(recovering == 0)
    80002f52:	fa0b18e3          	bnez	s6,80002f02 <install_trans+0x36>
      bunpin(dbuf);
    80002f56:	8526                	mv	a0,s1
    80002f58:	a96ff0ef          	jal	800021ee <bunpin>
    80002f5c:	b75d                	j	80002f02 <install_trans+0x36>
}
    80002f5e:	70e2                	ld	ra,56(sp)
    80002f60:	7442                	ld	s0,48(sp)
    80002f62:	74a2                	ld	s1,40(sp)
    80002f64:	7902                	ld	s2,32(sp)
    80002f66:	69e2                	ld	s3,24(sp)
    80002f68:	6a42                	ld	s4,16(sp)
    80002f6a:	6aa2                	ld	s5,8(sp)
    80002f6c:	6b02                	ld	s6,0(sp)
    80002f6e:	6121                	addi	sp,sp,64
    80002f70:	8082                	ret
    80002f72:	8082                	ret

0000000080002f74 <initlog>:
{
    80002f74:	7179                	addi	sp,sp,-48
    80002f76:	f406                	sd	ra,40(sp)
    80002f78:	f022                	sd	s0,32(sp)
    80002f7a:	ec26                	sd	s1,24(sp)
    80002f7c:	e84a                	sd	s2,16(sp)
    80002f7e:	e44e                	sd	s3,8(sp)
    80002f80:	1800                	addi	s0,sp,48
    80002f82:	892a                	mv	s2,a0
    80002f84:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80002f86:	00017497          	auipc	s1,0x17
    80002f8a:	4ea48493          	addi	s1,s1,1258 # 8001a470 <log>
    80002f8e:	00004597          	auipc	a1,0x4
    80002f92:	63258593          	addi	a1,a1,1586 # 800075c0 <etext+0x5c0>
    80002f96:	8526                	mv	a0,s1
    80002f98:	079020ef          	jal	80005810 <initlock>
  log.start = sb->logstart;
    80002f9c:	0149a583          	lw	a1,20(s3)
    80002fa0:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80002fa2:	0109a783          	lw	a5,16(s3)
    80002fa6:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80002fa8:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80002fac:	854a                	mv	a0,s2
    80002fae:	87cff0ef          	jal	8000202a <bread>
  log.lh.n = lh->n;
    80002fb2:	4d30                	lw	a2,88(a0)
    80002fb4:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80002fb6:	00c05f63          	blez	a2,80002fd4 <initlog+0x60>
    80002fba:	87aa                	mv	a5,a0
    80002fbc:	00017717          	auipc	a4,0x17
    80002fc0:	4e470713          	addi	a4,a4,1252 # 8001a4a0 <log+0x30>
    80002fc4:	060a                	slli	a2,a2,0x2
    80002fc6:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80002fc8:	4ff4                	lw	a3,92(a5)
    80002fca:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80002fcc:	0791                	addi	a5,a5,4
    80002fce:	0711                	addi	a4,a4,4
    80002fd0:	fec79ce3          	bne	a5,a2,80002fc8 <initlog+0x54>
  brelse(buf);
    80002fd4:	95eff0ef          	jal	80002132 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80002fd8:	4505                	li	a0,1
    80002fda:	ef3ff0ef          	jal	80002ecc <install_trans>
  log.lh.n = 0;
    80002fde:	00017797          	auipc	a5,0x17
    80002fe2:	4a07af23          	sw	zero,1214(a5) # 8001a49c <log+0x2c>
  write_head(); // clear the log
    80002fe6:	e89ff0ef          	jal	80002e6e <write_head>
}
    80002fea:	70a2                	ld	ra,40(sp)
    80002fec:	7402                	ld	s0,32(sp)
    80002fee:	64e2                	ld	s1,24(sp)
    80002ff0:	6942                	ld	s2,16(sp)
    80002ff2:	69a2                	ld	s3,8(sp)
    80002ff4:	6145                	addi	sp,sp,48
    80002ff6:	8082                	ret

0000000080002ff8 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80002ff8:	1101                	addi	sp,sp,-32
    80002ffa:	ec06                	sd	ra,24(sp)
    80002ffc:	e822                	sd	s0,16(sp)
    80002ffe:	e426                	sd	s1,8(sp)
    80003000:	e04a                	sd	s2,0(sp)
    80003002:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003004:	00017517          	auipc	a0,0x17
    80003008:	46c50513          	addi	a0,a0,1132 # 8001a470 <log>
    8000300c:	085020ef          	jal	80005890 <acquire>
  while(1){
    if(log.committing){
    80003010:	00017497          	auipc	s1,0x17
    80003014:	46048493          	addi	s1,s1,1120 # 8001a470 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003018:	4979                	li	s2,30
    8000301a:	a029                	j	80003024 <begin_op+0x2c>
      sleep(&log, &log.lock);
    8000301c:	85a6                	mv	a1,s1
    8000301e:	8526                	mv	a0,s1
    80003020:	b46fe0ef          	jal	80001366 <sleep>
    if(log.committing){
    80003024:	50dc                	lw	a5,36(s1)
    80003026:	fbfd                	bnez	a5,8000301c <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003028:	5098                	lw	a4,32(s1)
    8000302a:	2705                	addiw	a4,a4,1
    8000302c:	0027179b          	slliw	a5,a4,0x2
    80003030:	9fb9                	addw	a5,a5,a4
    80003032:	0017979b          	slliw	a5,a5,0x1
    80003036:	54d4                	lw	a3,44(s1)
    80003038:	9fb5                	addw	a5,a5,a3
    8000303a:	00f95763          	bge	s2,a5,80003048 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000303e:	85a6                	mv	a1,s1
    80003040:	8526                	mv	a0,s1
    80003042:	b24fe0ef          	jal	80001366 <sleep>
    80003046:	bff9                	j	80003024 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003048:	00017517          	auipc	a0,0x17
    8000304c:	42850513          	addi	a0,a0,1064 # 8001a470 <log>
    80003050:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003052:	0d7020ef          	jal	80005928 <release>
      break;
    }
  }
}
    80003056:	60e2                	ld	ra,24(sp)
    80003058:	6442                	ld	s0,16(sp)
    8000305a:	64a2                	ld	s1,8(sp)
    8000305c:	6902                	ld	s2,0(sp)
    8000305e:	6105                	addi	sp,sp,32
    80003060:	8082                	ret

0000000080003062 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003062:	7139                	addi	sp,sp,-64
    80003064:	fc06                	sd	ra,56(sp)
    80003066:	f822                	sd	s0,48(sp)
    80003068:	f426                	sd	s1,40(sp)
    8000306a:	f04a                	sd	s2,32(sp)
    8000306c:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000306e:	00017497          	auipc	s1,0x17
    80003072:	40248493          	addi	s1,s1,1026 # 8001a470 <log>
    80003076:	8526                	mv	a0,s1
    80003078:	019020ef          	jal	80005890 <acquire>
  log.outstanding -= 1;
    8000307c:	509c                	lw	a5,32(s1)
    8000307e:	37fd                	addiw	a5,a5,-1
    80003080:	0007891b          	sext.w	s2,a5
    80003084:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003086:	50dc                	lw	a5,36(s1)
    80003088:	ef9d                	bnez	a5,800030c6 <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    8000308a:	04091763          	bnez	s2,800030d8 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    8000308e:	00017497          	auipc	s1,0x17
    80003092:	3e248493          	addi	s1,s1,994 # 8001a470 <log>
    80003096:	4785                	li	a5,1
    80003098:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000309a:	8526                	mv	a0,s1
    8000309c:	08d020ef          	jal	80005928 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800030a0:	54dc                	lw	a5,44(s1)
    800030a2:	04f04b63          	bgtz	a5,800030f8 <end_op+0x96>
    acquire(&log.lock);
    800030a6:	00017497          	auipc	s1,0x17
    800030aa:	3ca48493          	addi	s1,s1,970 # 8001a470 <log>
    800030ae:	8526                	mv	a0,s1
    800030b0:	7e0020ef          	jal	80005890 <acquire>
    log.committing = 0;
    800030b4:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800030b8:	8526                	mv	a0,s1
    800030ba:	af8fe0ef          	jal	800013b2 <wakeup>
    release(&log.lock);
    800030be:	8526                	mv	a0,s1
    800030c0:	069020ef          	jal	80005928 <release>
}
    800030c4:	a025                	j	800030ec <end_op+0x8a>
    800030c6:	ec4e                	sd	s3,24(sp)
    800030c8:	e852                	sd	s4,16(sp)
    800030ca:	e456                	sd	s5,8(sp)
    panic("log.committing");
    800030cc:	00004517          	auipc	a0,0x4
    800030d0:	4fc50513          	addi	a0,a0,1276 # 800075c8 <etext+0x5c8>
    800030d4:	48e020ef          	jal	80005562 <panic>
    wakeup(&log);
    800030d8:	00017497          	auipc	s1,0x17
    800030dc:	39848493          	addi	s1,s1,920 # 8001a470 <log>
    800030e0:	8526                	mv	a0,s1
    800030e2:	ad0fe0ef          	jal	800013b2 <wakeup>
  release(&log.lock);
    800030e6:	8526                	mv	a0,s1
    800030e8:	041020ef          	jal	80005928 <release>
}
    800030ec:	70e2                	ld	ra,56(sp)
    800030ee:	7442                	ld	s0,48(sp)
    800030f0:	74a2                	ld	s1,40(sp)
    800030f2:	7902                	ld	s2,32(sp)
    800030f4:	6121                	addi	sp,sp,64
    800030f6:	8082                	ret
    800030f8:	ec4e                	sd	s3,24(sp)
    800030fa:	e852                	sd	s4,16(sp)
    800030fc:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800030fe:	00017a97          	auipc	s5,0x17
    80003102:	3a2a8a93          	addi	s5,s5,930 # 8001a4a0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003106:	00017a17          	auipc	s4,0x17
    8000310a:	36aa0a13          	addi	s4,s4,874 # 8001a470 <log>
    8000310e:	018a2583          	lw	a1,24(s4)
    80003112:	012585bb          	addw	a1,a1,s2
    80003116:	2585                	addiw	a1,a1,1
    80003118:	028a2503          	lw	a0,40(s4)
    8000311c:	f0ffe0ef          	jal	8000202a <bread>
    80003120:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003122:	000aa583          	lw	a1,0(s5)
    80003126:	028a2503          	lw	a0,40(s4)
    8000312a:	f01fe0ef          	jal	8000202a <bread>
    8000312e:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003130:	40000613          	li	a2,1024
    80003134:	05850593          	addi	a1,a0,88
    80003138:	05848513          	addi	a0,s1,88
    8000313c:	896fd0ef          	jal	800001d2 <memmove>
    bwrite(to);  // write the log
    80003140:	8526                	mv	a0,s1
    80003142:	fbffe0ef          	jal	80002100 <bwrite>
    brelse(from);
    80003146:	854e                	mv	a0,s3
    80003148:	febfe0ef          	jal	80002132 <brelse>
    brelse(to);
    8000314c:	8526                	mv	a0,s1
    8000314e:	fe5fe0ef          	jal	80002132 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003152:	2905                	addiw	s2,s2,1
    80003154:	0a91                	addi	s5,s5,4
    80003156:	02ca2783          	lw	a5,44(s4)
    8000315a:	faf94ae3          	blt	s2,a5,8000310e <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000315e:	d11ff0ef          	jal	80002e6e <write_head>
    install_trans(0); // Now install writes to home locations
    80003162:	4501                	li	a0,0
    80003164:	d69ff0ef          	jal	80002ecc <install_trans>
    log.lh.n = 0;
    80003168:	00017797          	auipc	a5,0x17
    8000316c:	3207aa23          	sw	zero,820(a5) # 8001a49c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003170:	cffff0ef          	jal	80002e6e <write_head>
    80003174:	69e2                	ld	s3,24(sp)
    80003176:	6a42                	ld	s4,16(sp)
    80003178:	6aa2                	ld	s5,8(sp)
    8000317a:	b735                	j	800030a6 <end_op+0x44>

000000008000317c <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000317c:	1101                	addi	sp,sp,-32
    8000317e:	ec06                	sd	ra,24(sp)
    80003180:	e822                	sd	s0,16(sp)
    80003182:	e426                	sd	s1,8(sp)
    80003184:	e04a                	sd	s2,0(sp)
    80003186:	1000                	addi	s0,sp,32
    80003188:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000318a:	00017917          	auipc	s2,0x17
    8000318e:	2e690913          	addi	s2,s2,742 # 8001a470 <log>
    80003192:	854a                	mv	a0,s2
    80003194:	6fc020ef          	jal	80005890 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003198:	02c92603          	lw	a2,44(s2)
    8000319c:	47f5                	li	a5,29
    8000319e:	06c7c363          	blt	a5,a2,80003204 <log_write+0x88>
    800031a2:	00017797          	auipc	a5,0x17
    800031a6:	2ea7a783          	lw	a5,746(a5) # 8001a48c <log+0x1c>
    800031aa:	37fd                	addiw	a5,a5,-1
    800031ac:	04f65c63          	bge	a2,a5,80003204 <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800031b0:	00017797          	auipc	a5,0x17
    800031b4:	2e07a783          	lw	a5,736(a5) # 8001a490 <log+0x20>
    800031b8:	04f05c63          	blez	a5,80003210 <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800031bc:	4781                	li	a5,0
    800031be:	04c05f63          	blez	a2,8000321c <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800031c2:	44cc                	lw	a1,12(s1)
    800031c4:	00017717          	auipc	a4,0x17
    800031c8:	2dc70713          	addi	a4,a4,732 # 8001a4a0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800031cc:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800031ce:	4314                	lw	a3,0(a4)
    800031d0:	04b68663          	beq	a3,a1,8000321c <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    800031d4:	2785                	addiw	a5,a5,1
    800031d6:	0711                	addi	a4,a4,4
    800031d8:	fef61be3          	bne	a2,a5,800031ce <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    800031dc:	0621                	addi	a2,a2,8
    800031de:	060a                	slli	a2,a2,0x2
    800031e0:	00017797          	auipc	a5,0x17
    800031e4:	29078793          	addi	a5,a5,656 # 8001a470 <log>
    800031e8:	97b2                	add	a5,a5,a2
    800031ea:	44d8                	lw	a4,12(s1)
    800031ec:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800031ee:	8526                	mv	a0,s1
    800031f0:	fcbfe0ef          	jal	800021ba <bpin>
    log.lh.n++;
    800031f4:	00017717          	auipc	a4,0x17
    800031f8:	27c70713          	addi	a4,a4,636 # 8001a470 <log>
    800031fc:	575c                	lw	a5,44(a4)
    800031fe:	2785                	addiw	a5,a5,1
    80003200:	d75c                	sw	a5,44(a4)
    80003202:	a80d                	j	80003234 <log_write+0xb8>
    panic("too big a transaction");
    80003204:	00004517          	auipc	a0,0x4
    80003208:	3d450513          	addi	a0,a0,980 # 800075d8 <etext+0x5d8>
    8000320c:	356020ef          	jal	80005562 <panic>
    panic("log_write outside of trans");
    80003210:	00004517          	auipc	a0,0x4
    80003214:	3e050513          	addi	a0,a0,992 # 800075f0 <etext+0x5f0>
    80003218:	34a020ef          	jal	80005562 <panic>
  log.lh.block[i] = b->blockno;
    8000321c:	00878693          	addi	a3,a5,8
    80003220:	068a                	slli	a3,a3,0x2
    80003222:	00017717          	auipc	a4,0x17
    80003226:	24e70713          	addi	a4,a4,590 # 8001a470 <log>
    8000322a:	9736                	add	a4,a4,a3
    8000322c:	44d4                	lw	a3,12(s1)
    8000322e:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003230:	faf60fe3          	beq	a2,a5,800031ee <log_write+0x72>
  }
  release(&log.lock);
    80003234:	00017517          	auipc	a0,0x17
    80003238:	23c50513          	addi	a0,a0,572 # 8001a470 <log>
    8000323c:	6ec020ef          	jal	80005928 <release>
}
    80003240:	60e2                	ld	ra,24(sp)
    80003242:	6442                	ld	s0,16(sp)
    80003244:	64a2                	ld	s1,8(sp)
    80003246:	6902                	ld	s2,0(sp)
    80003248:	6105                	addi	sp,sp,32
    8000324a:	8082                	ret

000000008000324c <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000324c:	1101                	addi	sp,sp,-32
    8000324e:	ec06                	sd	ra,24(sp)
    80003250:	e822                	sd	s0,16(sp)
    80003252:	e426                	sd	s1,8(sp)
    80003254:	e04a                	sd	s2,0(sp)
    80003256:	1000                	addi	s0,sp,32
    80003258:	84aa                	mv	s1,a0
    8000325a:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000325c:	00004597          	auipc	a1,0x4
    80003260:	3b458593          	addi	a1,a1,948 # 80007610 <etext+0x610>
    80003264:	0521                	addi	a0,a0,8
    80003266:	5aa020ef          	jal	80005810 <initlock>
  lk->name = name;
    8000326a:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000326e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003272:	0204a423          	sw	zero,40(s1)
}
    80003276:	60e2                	ld	ra,24(sp)
    80003278:	6442                	ld	s0,16(sp)
    8000327a:	64a2                	ld	s1,8(sp)
    8000327c:	6902                	ld	s2,0(sp)
    8000327e:	6105                	addi	sp,sp,32
    80003280:	8082                	ret

0000000080003282 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003282:	1101                	addi	sp,sp,-32
    80003284:	ec06                	sd	ra,24(sp)
    80003286:	e822                	sd	s0,16(sp)
    80003288:	e426                	sd	s1,8(sp)
    8000328a:	e04a                	sd	s2,0(sp)
    8000328c:	1000                	addi	s0,sp,32
    8000328e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003290:	00850913          	addi	s2,a0,8
    80003294:	854a                	mv	a0,s2
    80003296:	5fa020ef          	jal	80005890 <acquire>
  while (lk->locked) {
    8000329a:	409c                	lw	a5,0(s1)
    8000329c:	c799                	beqz	a5,800032aa <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    8000329e:	85ca                	mv	a1,s2
    800032a0:	8526                	mv	a0,s1
    800032a2:	8c4fe0ef          	jal	80001366 <sleep>
  while (lk->locked) {
    800032a6:	409c                	lw	a5,0(s1)
    800032a8:	fbfd                	bnez	a5,8000329e <acquiresleep+0x1c>
  }
  lk->locked = 1;
    800032aa:	4785                	li	a5,1
    800032ac:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800032ae:	aebfd0ef          	jal	80000d98 <myproc>
    800032b2:	591c                	lw	a5,48(a0)
    800032b4:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800032b6:	854a                	mv	a0,s2
    800032b8:	670020ef          	jal	80005928 <release>
}
    800032bc:	60e2                	ld	ra,24(sp)
    800032be:	6442                	ld	s0,16(sp)
    800032c0:	64a2                	ld	s1,8(sp)
    800032c2:	6902                	ld	s2,0(sp)
    800032c4:	6105                	addi	sp,sp,32
    800032c6:	8082                	ret

00000000800032c8 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800032c8:	1101                	addi	sp,sp,-32
    800032ca:	ec06                	sd	ra,24(sp)
    800032cc:	e822                	sd	s0,16(sp)
    800032ce:	e426                	sd	s1,8(sp)
    800032d0:	e04a                	sd	s2,0(sp)
    800032d2:	1000                	addi	s0,sp,32
    800032d4:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800032d6:	00850913          	addi	s2,a0,8
    800032da:	854a                	mv	a0,s2
    800032dc:	5b4020ef          	jal	80005890 <acquire>
  lk->locked = 0;
    800032e0:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800032e4:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800032e8:	8526                	mv	a0,s1
    800032ea:	8c8fe0ef          	jal	800013b2 <wakeup>
  release(&lk->lk);
    800032ee:	854a                	mv	a0,s2
    800032f0:	638020ef          	jal	80005928 <release>
}
    800032f4:	60e2                	ld	ra,24(sp)
    800032f6:	6442                	ld	s0,16(sp)
    800032f8:	64a2                	ld	s1,8(sp)
    800032fa:	6902                	ld	s2,0(sp)
    800032fc:	6105                	addi	sp,sp,32
    800032fe:	8082                	ret

0000000080003300 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003300:	7179                	addi	sp,sp,-48
    80003302:	f406                	sd	ra,40(sp)
    80003304:	f022                	sd	s0,32(sp)
    80003306:	ec26                	sd	s1,24(sp)
    80003308:	e84a                	sd	s2,16(sp)
    8000330a:	1800                	addi	s0,sp,48
    8000330c:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000330e:	00850913          	addi	s2,a0,8
    80003312:	854a                	mv	a0,s2
    80003314:	57c020ef          	jal	80005890 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003318:	409c                	lw	a5,0(s1)
    8000331a:	ef81                	bnez	a5,80003332 <holdingsleep+0x32>
    8000331c:	4481                	li	s1,0
  release(&lk->lk);
    8000331e:	854a                	mv	a0,s2
    80003320:	608020ef          	jal	80005928 <release>
  return r;
}
    80003324:	8526                	mv	a0,s1
    80003326:	70a2                	ld	ra,40(sp)
    80003328:	7402                	ld	s0,32(sp)
    8000332a:	64e2                	ld	s1,24(sp)
    8000332c:	6942                	ld	s2,16(sp)
    8000332e:	6145                	addi	sp,sp,48
    80003330:	8082                	ret
    80003332:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003334:	0284a983          	lw	s3,40(s1)
    80003338:	a61fd0ef          	jal	80000d98 <myproc>
    8000333c:	5904                	lw	s1,48(a0)
    8000333e:	413484b3          	sub	s1,s1,s3
    80003342:	0014b493          	seqz	s1,s1
    80003346:	69a2                	ld	s3,8(sp)
    80003348:	bfd9                	j	8000331e <holdingsleep+0x1e>

000000008000334a <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000334a:	1141                	addi	sp,sp,-16
    8000334c:	e406                	sd	ra,8(sp)
    8000334e:	e022                	sd	s0,0(sp)
    80003350:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003352:	00004597          	auipc	a1,0x4
    80003356:	2ce58593          	addi	a1,a1,718 # 80007620 <etext+0x620>
    8000335a:	00017517          	auipc	a0,0x17
    8000335e:	25e50513          	addi	a0,a0,606 # 8001a5b8 <ftable>
    80003362:	4ae020ef          	jal	80005810 <initlock>
}
    80003366:	60a2                	ld	ra,8(sp)
    80003368:	6402                	ld	s0,0(sp)
    8000336a:	0141                	addi	sp,sp,16
    8000336c:	8082                	ret

000000008000336e <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    8000336e:	1101                	addi	sp,sp,-32
    80003370:	ec06                	sd	ra,24(sp)
    80003372:	e822                	sd	s0,16(sp)
    80003374:	e426                	sd	s1,8(sp)
    80003376:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003378:	00017517          	auipc	a0,0x17
    8000337c:	24050513          	addi	a0,a0,576 # 8001a5b8 <ftable>
    80003380:	510020ef          	jal	80005890 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003384:	00017497          	auipc	s1,0x17
    80003388:	24c48493          	addi	s1,s1,588 # 8001a5d0 <ftable+0x18>
    8000338c:	00018717          	auipc	a4,0x18
    80003390:	1e470713          	addi	a4,a4,484 # 8001b570 <disk>
    if(f->ref == 0){
    80003394:	40dc                	lw	a5,4(s1)
    80003396:	cf89                	beqz	a5,800033b0 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003398:	02848493          	addi	s1,s1,40
    8000339c:	fee49ce3          	bne	s1,a4,80003394 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800033a0:	00017517          	auipc	a0,0x17
    800033a4:	21850513          	addi	a0,a0,536 # 8001a5b8 <ftable>
    800033a8:	580020ef          	jal	80005928 <release>
  return 0;
    800033ac:	4481                	li	s1,0
    800033ae:	a809                	j	800033c0 <filealloc+0x52>
      f->ref = 1;
    800033b0:	4785                	li	a5,1
    800033b2:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800033b4:	00017517          	auipc	a0,0x17
    800033b8:	20450513          	addi	a0,a0,516 # 8001a5b8 <ftable>
    800033bc:	56c020ef          	jal	80005928 <release>
}
    800033c0:	8526                	mv	a0,s1
    800033c2:	60e2                	ld	ra,24(sp)
    800033c4:	6442                	ld	s0,16(sp)
    800033c6:	64a2                	ld	s1,8(sp)
    800033c8:	6105                	addi	sp,sp,32
    800033ca:	8082                	ret

00000000800033cc <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800033cc:	1101                	addi	sp,sp,-32
    800033ce:	ec06                	sd	ra,24(sp)
    800033d0:	e822                	sd	s0,16(sp)
    800033d2:	e426                	sd	s1,8(sp)
    800033d4:	1000                	addi	s0,sp,32
    800033d6:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800033d8:	00017517          	auipc	a0,0x17
    800033dc:	1e050513          	addi	a0,a0,480 # 8001a5b8 <ftable>
    800033e0:	4b0020ef          	jal	80005890 <acquire>
  if(f->ref < 1)
    800033e4:	40dc                	lw	a5,4(s1)
    800033e6:	02f05063          	blez	a5,80003406 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    800033ea:	2785                	addiw	a5,a5,1
    800033ec:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800033ee:	00017517          	auipc	a0,0x17
    800033f2:	1ca50513          	addi	a0,a0,458 # 8001a5b8 <ftable>
    800033f6:	532020ef          	jal	80005928 <release>
  return f;
}
    800033fa:	8526                	mv	a0,s1
    800033fc:	60e2                	ld	ra,24(sp)
    800033fe:	6442                	ld	s0,16(sp)
    80003400:	64a2                	ld	s1,8(sp)
    80003402:	6105                	addi	sp,sp,32
    80003404:	8082                	ret
    panic("filedup");
    80003406:	00004517          	auipc	a0,0x4
    8000340a:	22250513          	addi	a0,a0,546 # 80007628 <etext+0x628>
    8000340e:	154020ef          	jal	80005562 <panic>

0000000080003412 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003412:	7139                	addi	sp,sp,-64
    80003414:	fc06                	sd	ra,56(sp)
    80003416:	f822                	sd	s0,48(sp)
    80003418:	f426                	sd	s1,40(sp)
    8000341a:	0080                	addi	s0,sp,64
    8000341c:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    8000341e:	00017517          	auipc	a0,0x17
    80003422:	19a50513          	addi	a0,a0,410 # 8001a5b8 <ftable>
    80003426:	46a020ef          	jal	80005890 <acquire>
  if(f->ref < 1)
    8000342a:	40dc                	lw	a5,4(s1)
    8000342c:	04f05a63          	blez	a5,80003480 <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    80003430:	37fd                	addiw	a5,a5,-1
    80003432:	0007871b          	sext.w	a4,a5
    80003436:	c0dc                	sw	a5,4(s1)
    80003438:	04e04e63          	bgtz	a4,80003494 <fileclose+0x82>
    8000343c:	f04a                	sd	s2,32(sp)
    8000343e:	ec4e                	sd	s3,24(sp)
    80003440:	e852                	sd	s4,16(sp)
    80003442:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003444:	0004a903          	lw	s2,0(s1)
    80003448:	0094ca83          	lbu	s5,9(s1)
    8000344c:	0104ba03          	ld	s4,16(s1)
    80003450:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003454:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003458:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    8000345c:	00017517          	auipc	a0,0x17
    80003460:	15c50513          	addi	a0,a0,348 # 8001a5b8 <ftable>
    80003464:	4c4020ef          	jal	80005928 <release>

  if(ff.type == FD_PIPE){
    80003468:	4785                	li	a5,1
    8000346a:	04f90063          	beq	s2,a5,800034aa <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    8000346e:	3979                	addiw	s2,s2,-2
    80003470:	4785                	li	a5,1
    80003472:	0527f563          	bgeu	a5,s2,800034bc <fileclose+0xaa>
    80003476:	7902                	ld	s2,32(sp)
    80003478:	69e2                	ld	s3,24(sp)
    8000347a:	6a42                	ld	s4,16(sp)
    8000347c:	6aa2                	ld	s5,8(sp)
    8000347e:	a00d                	j	800034a0 <fileclose+0x8e>
    80003480:	f04a                	sd	s2,32(sp)
    80003482:	ec4e                	sd	s3,24(sp)
    80003484:	e852                	sd	s4,16(sp)
    80003486:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003488:	00004517          	auipc	a0,0x4
    8000348c:	1a850513          	addi	a0,a0,424 # 80007630 <etext+0x630>
    80003490:	0d2020ef          	jal	80005562 <panic>
    release(&ftable.lock);
    80003494:	00017517          	auipc	a0,0x17
    80003498:	12450513          	addi	a0,a0,292 # 8001a5b8 <ftable>
    8000349c:	48c020ef          	jal	80005928 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    800034a0:	70e2                	ld	ra,56(sp)
    800034a2:	7442                	ld	s0,48(sp)
    800034a4:	74a2                	ld	s1,40(sp)
    800034a6:	6121                	addi	sp,sp,64
    800034a8:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800034aa:	85d6                	mv	a1,s5
    800034ac:	8552                	mv	a0,s4
    800034ae:	386000ef          	jal	80003834 <pipeclose>
    800034b2:	7902                	ld	s2,32(sp)
    800034b4:	69e2                	ld	s3,24(sp)
    800034b6:	6a42                	ld	s4,16(sp)
    800034b8:	6aa2                	ld	s5,8(sp)
    800034ba:	b7dd                	j	800034a0 <fileclose+0x8e>
    begin_op();
    800034bc:	b3dff0ef          	jal	80002ff8 <begin_op>
    iput(ff.ip);
    800034c0:	854e                	mv	a0,s3
    800034c2:	c22ff0ef          	jal	800028e4 <iput>
    end_op();
    800034c6:	b9dff0ef          	jal	80003062 <end_op>
    800034ca:	7902                	ld	s2,32(sp)
    800034cc:	69e2                	ld	s3,24(sp)
    800034ce:	6a42                	ld	s4,16(sp)
    800034d0:	6aa2                	ld	s5,8(sp)
    800034d2:	b7f9                	j	800034a0 <fileclose+0x8e>

00000000800034d4 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800034d4:	715d                	addi	sp,sp,-80
    800034d6:	e486                	sd	ra,72(sp)
    800034d8:	e0a2                	sd	s0,64(sp)
    800034da:	fc26                	sd	s1,56(sp)
    800034dc:	f44e                	sd	s3,40(sp)
    800034de:	0880                	addi	s0,sp,80
    800034e0:	84aa                	mv	s1,a0
    800034e2:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800034e4:	8b5fd0ef          	jal	80000d98 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800034e8:	409c                	lw	a5,0(s1)
    800034ea:	37f9                	addiw	a5,a5,-2
    800034ec:	4705                	li	a4,1
    800034ee:	04f76063          	bltu	a4,a5,8000352e <filestat+0x5a>
    800034f2:	f84a                	sd	s2,48(sp)
    800034f4:	892a                	mv	s2,a0
    ilock(f->ip);
    800034f6:	6c88                	ld	a0,24(s1)
    800034f8:	a6aff0ef          	jal	80002762 <ilock>
    stati(f->ip, &st);
    800034fc:	fb840593          	addi	a1,s0,-72
    80003500:	6c88                	ld	a0,24(s1)
    80003502:	c8aff0ef          	jal	8000298c <stati>
    iunlock(f->ip);
    80003506:	6c88                	ld	a0,24(s1)
    80003508:	b08ff0ef          	jal	80002810 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    8000350c:	46e1                	li	a3,24
    8000350e:	fb840613          	addi	a2,s0,-72
    80003512:	85ce                	mv	a1,s3
    80003514:	05093503          	ld	a0,80(s2)
    80003518:	cf0fd0ef          	jal	80000a08 <copyout>
    8000351c:	41f5551b          	sraiw	a0,a0,0x1f
    80003520:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003522:	60a6                	ld	ra,72(sp)
    80003524:	6406                	ld	s0,64(sp)
    80003526:	74e2                	ld	s1,56(sp)
    80003528:	79a2                	ld	s3,40(sp)
    8000352a:	6161                	addi	sp,sp,80
    8000352c:	8082                	ret
  return -1;
    8000352e:	557d                	li	a0,-1
    80003530:	bfcd                	j	80003522 <filestat+0x4e>

0000000080003532 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003532:	7179                	addi	sp,sp,-48
    80003534:	f406                	sd	ra,40(sp)
    80003536:	f022                	sd	s0,32(sp)
    80003538:	e84a                	sd	s2,16(sp)
    8000353a:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    8000353c:	00854783          	lbu	a5,8(a0)
    80003540:	cfd1                	beqz	a5,800035dc <fileread+0xaa>
    80003542:	ec26                	sd	s1,24(sp)
    80003544:	e44e                	sd	s3,8(sp)
    80003546:	84aa                	mv	s1,a0
    80003548:	89ae                	mv	s3,a1
    8000354a:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    8000354c:	411c                	lw	a5,0(a0)
    8000354e:	4705                	li	a4,1
    80003550:	04e78363          	beq	a5,a4,80003596 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003554:	470d                	li	a4,3
    80003556:	04e78763          	beq	a5,a4,800035a4 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    8000355a:	4709                	li	a4,2
    8000355c:	06e79a63          	bne	a5,a4,800035d0 <fileread+0x9e>
    ilock(f->ip);
    80003560:	6d08                	ld	a0,24(a0)
    80003562:	a00ff0ef          	jal	80002762 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003566:	874a                	mv	a4,s2
    80003568:	5094                	lw	a3,32(s1)
    8000356a:	864e                	mv	a2,s3
    8000356c:	4585                	li	a1,1
    8000356e:	6c88                	ld	a0,24(s1)
    80003570:	c46ff0ef          	jal	800029b6 <readi>
    80003574:	892a                	mv	s2,a0
    80003576:	00a05563          	blez	a0,80003580 <fileread+0x4e>
      f->off += r;
    8000357a:	509c                	lw	a5,32(s1)
    8000357c:	9fa9                	addw	a5,a5,a0
    8000357e:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003580:	6c88                	ld	a0,24(s1)
    80003582:	a8eff0ef          	jal	80002810 <iunlock>
    80003586:	64e2                	ld	s1,24(sp)
    80003588:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    8000358a:	854a                	mv	a0,s2
    8000358c:	70a2                	ld	ra,40(sp)
    8000358e:	7402                	ld	s0,32(sp)
    80003590:	6942                	ld	s2,16(sp)
    80003592:	6145                	addi	sp,sp,48
    80003594:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003596:	6908                	ld	a0,16(a0)
    80003598:	3d8000ef          	jal	80003970 <piperead>
    8000359c:	892a                	mv	s2,a0
    8000359e:	64e2                	ld	s1,24(sp)
    800035a0:	69a2                	ld	s3,8(sp)
    800035a2:	b7e5                	j	8000358a <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800035a4:	02451783          	lh	a5,36(a0)
    800035a8:	03079693          	slli	a3,a5,0x30
    800035ac:	92c1                	srli	a3,a3,0x30
    800035ae:	4725                	li	a4,9
    800035b0:	02d76863          	bltu	a4,a3,800035e0 <fileread+0xae>
    800035b4:	0792                	slli	a5,a5,0x4
    800035b6:	00017717          	auipc	a4,0x17
    800035ba:	f6270713          	addi	a4,a4,-158 # 8001a518 <devsw>
    800035be:	97ba                	add	a5,a5,a4
    800035c0:	639c                	ld	a5,0(a5)
    800035c2:	c39d                	beqz	a5,800035e8 <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    800035c4:	4505                	li	a0,1
    800035c6:	9782                	jalr	a5
    800035c8:	892a                	mv	s2,a0
    800035ca:	64e2                	ld	s1,24(sp)
    800035cc:	69a2                	ld	s3,8(sp)
    800035ce:	bf75                	j	8000358a <fileread+0x58>
    panic("fileread");
    800035d0:	00004517          	auipc	a0,0x4
    800035d4:	07050513          	addi	a0,a0,112 # 80007640 <etext+0x640>
    800035d8:	78b010ef          	jal	80005562 <panic>
    return -1;
    800035dc:	597d                	li	s2,-1
    800035de:	b775                	j	8000358a <fileread+0x58>
      return -1;
    800035e0:	597d                	li	s2,-1
    800035e2:	64e2                	ld	s1,24(sp)
    800035e4:	69a2                	ld	s3,8(sp)
    800035e6:	b755                	j	8000358a <fileread+0x58>
    800035e8:	597d                	li	s2,-1
    800035ea:	64e2                	ld	s1,24(sp)
    800035ec:	69a2                	ld	s3,8(sp)
    800035ee:	bf71                	j	8000358a <fileread+0x58>

00000000800035f0 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    800035f0:	00954783          	lbu	a5,9(a0)
    800035f4:	10078b63          	beqz	a5,8000370a <filewrite+0x11a>
{
    800035f8:	715d                	addi	sp,sp,-80
    800035fa:	e486                	sd	ra,72(sp)
    800035fc:	e0a2                	sd	s0,64(sp)
    800035fe:	f84a                	sd	s2,48(sp)
    80003600:	f052                	sd	s4,32(sp)
    80003602:	e85a                	sd	s6,16(sp)
    80003604:	0880                	addi	s0,sp,80
    80003606:	892a                	mv	s2,a0
    80003608:	8b2e                	mv	s6,a1
    8000360a:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    8000360c:	411c                	lw	a5,0(a0)
    8000360e:	4705                	li	a4,1
    80003610:	02e78763          	beq	a5,a4,8000363e <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003614:	470d                	li	a4,3
    80003616:	02e78863          	beq	a5,a4,80003646 <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    8000361a:	4709                	li	a4,2
    8000361c:	0ce79c63          	bne	a5,a4,800036f4 <filewrite+0x104>
    80003620:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003622:	0ac05863          	blez	a2,800036d2 <filewrite+0xe2>
    80003626:	fc26                	sd	s1,56(sp)
    80003628:	ec56                	sd	s5,24(sp)
    8000362a:	e45e                	sd	s7,8(sp)
    8000362c:	e062                	sd	s8,0(sp)
    int i = 0;
    8000362e:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003630:	6b85                	lui	s7,0x1
    80003632:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003636:	6c05                	lui	s8,0x1
    80003638:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    8000363c:	a8b5                	j	800036b8 <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    8000363e:	6908                	ld	a0,16(a0)
    80003640:	24c000ef          	jal	8000388c <pipewrite>
    80003644:	a04d                	j	800036e6 <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003646:	02451783          	lh	a5,36(a0)
    8000364a:	03079693          	slli	a3,a5,0x30
    8000364e:	92c1                	srli	a3,a3,0x30
    80003650:	4725                	li	a4,9
    80003652:	0ad76e63          	bltu	a4,a3,8000370e <filewrite+0x11e>
    80003656:	0792                	slli	a5,a5,0x4
    80003658:	00017717          	auipc	a4,0x17
    8000365c:	ec070713          	addi	a4,a4,-320 # 8001a518 <devsw>
    80003660:	97ba                	add	a5,a5,a4
    80003662:	679c                	ld	a5,8(a5)
    80003664:	c7dd                	beqz	a5,80003712 <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    80003666:	4505                	li	a0,1
    80003668:	9782                	jalr	a5
    8000366a:	a8b5                	j	800036e6 <filewrite+0xf6>
      if(n1 > max)
    8000366c:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003670:	989ff0ef          	jal	80002ff8 <begin_op>
      ilock(f->ip);
    80003674:	01893503          	ld	a0,24(s2)
    80003678:	8eaff0ef          	jal	80002762 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000367c:	8756                	mv	a4,s5
    8000367e:	02092683          	lw	a3,32(s2)
    80003682:	01698633          	add	a2,s3,s6
    80003686:	4585                	li	a1,1
    80003688:	01893503          	ld	a0,24(s2)
    8000368c:	c26ff0ef          	jal	80002ab2 <writei>
    80003690:	84aa                	mv	s1,a0
    80003692:	00a05763          	blez	a0,800036a0 <filewrite+0xb0>
        f->off += r;
    80003696:	02092783          	lw	a5,32(s2)
    8000369a:	9fa9                	addw	a5,a5,a0
    8000369c:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800036a0:	01893503          	ld	a0,24(s2)
    800036a4:	96cff0ef          	jal	80002810 <iunlock>
      end_op();
    800036a8:	9bbff0ef          	jal	80003062 <end_op>

      if(r != n1){
    800036ac:	029a9563          	bne	s5,s1,800036d6 <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    800036b0:	013489bb          	addw	s3,s1,s3
    while(i < n){
    800036b4:	0149da63          	bge	s3,s4,800036c8 <filewrite+0xd8>
      int n1 = n - i;
    800036b8:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    800036bc:	0004879b          	sext.w	a5,s1
    800036c0:	fafbd6e3          	bge	s7,a5,8000366c <filewrite+0x7c>
    800036c4:	84e2                	mv	s1,s8
    800036c6:	b75d                	j	8000366c <filewrite+0x7c>
    800036c8:	74e2                	ld	s1,56(sp)
    800036ca:	6ae2                	ld	s5,24(sp)
    800036cc:	6ba2                	ld	s7,8(sp)
    800036ce:	6c02                	ld	s8,0(sp)
    800036d0:	a039                	j	800036de <filewrite+0xee>
    int i = 0;
    800036d2:	4981                	li	s3,0
    800036d4:	a029                	j	800036de <filewrite+0xee>
    800036d6:	74e2                	ld	s1,56(sp)
    800036d8:	6ae2                	ld	s5,24(sp)
    800036da:	6ba2                	ld	s7,8(sp)
    800036dc:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    800036de:	033a1c63          	bne	s4,s3,80003716 <filewrite+0x126>
    800036e2:	8552                	mv	a0,s4
    800036e4:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    800036e6:	60a6                	ld	ra,72(sp)
    800036e8:	6406                	ld	s0,64(sp)
    800036ea:	7942                	ld	s2,48(sp)
    800036ec:	7a02                	ld	s4,32(sp)
    800036ee:	6b42                	ld	s6,16(sp)
    800036f0:	6161                	addi	sp,sp,80
    800036f2:	8082                	ret
    800036f4:	fc26                	sd	s1,56(sp)
    800036f6:	f44e                	sd	s3,40(sp)
    800036f8:	ec56                	sd	s5,24(sp)
    800036fa:	e45e                	sd	s7,8(sp)
    800036fc:	e062                	sd	s8,0(sp)
    panic("filewrite");
    800036fe:	00004517          	auipc	a0,0x4
    80003702:	f5250513          	addi	a0,a0,-174 # 80007650 <etext+0x650>
    80003706:	65d010ef          	jal	80005562 <panic>
    return -1;
    8000370a:	557d                	li	a0,-1
}
    8000370c:	8082                	ret
      return -1;
    8000370e:	557d                	li	a0,-1
    80003710:	bfd9                	j	800036e6 <filewrite+0xf6>
    80003712:	557d                	li	a0,-1
    80003714:	bfc9                	j	800036e6 <filewrite+0xf6>
    ret = (i == n ? n : -1);
    80003716:	557d                	li	a0,-1
    80003718:	79a2                	ld	s3,40(sp)
    8000371a:	b7f1                	j	800036e6 <filewrite+0xf6>

000000008000371c <nopenfiles_count>:

uint64
nopenfiles_count(void)
{
    8000371c:	1101                	addi	sp,sp,-32
    8000371e:	ec06                	sd	ra,24(sp)
    80003720:	e822                	sd	s0,16(sp)
    80003722:	e426                	sd	s1,8(sp)
    80003724:	1000                	addi	s0,sp,32
  struct file *f;
  uint64 count = 0;

  acquire(&ftable.lock);
    80003726:	00017517          	auipc	a0,0x17
    8000372a:	e9250513          	addi	a0,a0,-366 # 8001a5b8 <ftable>
    8000372e:	162020ef          	jal	80005890 <acquire>
  uint64 count = 0;
    80003732:	4481                	li	s1,0

  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003734:	00017797          	auipc	a5,0x17
    80003738:	e9c78793          	addi	a5,a5,-356 # 8001a5d0 <ftable+0x18>
    8000373c:	00018697          	auipc	a3,0x18
    80003740:	e3468693          	addi	a3,a3,-460 # 8001b570 <disk>
    if(f->ref > 0)
    80003744:	43d8                	lw	a4,4(a5)
      count++;
    80003746:	00e02733          	sgtz	a4,a4
    8000374a:	94ba                	add	s1,s1,a4
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000374c:	02878793          	addi	a5,a5,40
    80003750:	fed79ae3          	bne	a5,a3,80003744 <nopenfiles_count+0x28>
  }

  release(&ftable.lock);
    80003754:	00017517          	auipc	a0,0x17
    80003758:	e6450513          	addi	a0,a0,-412 # 8001a5b8 <ftable>
    8000375c:	1cc020ef          	jal	80005928 <release>
  return count;
    80003760:	8526                	mv	a0,s1
    80003762:	60e2                	ld	ra,24(sp)
    80003764:	6442                	ld	s0,16(sp)
    80003766:	64a2                	ld	s1,8(sp)
    80003768:	6105                	addi	sp,sp,32
    8000376a:	8082                	ret

000000008000376c <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    8000376c:	7179                	addi	sp,sp,-48
    8000376e:	f406                	sd	ra,40(sp)
    80003770:	f022                	sd	s0,32(sp)
    80003772:	ec26                	sd	s1,24(sp)
    80003774:	e052                	sd	s4,0(sp)
    80003776:	1800                	addi	s0,sp,48
    80003778:	84aa                	mv	s1,a0
    8000377a:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    8000377c:	0005b023          	sd	zero,0(a1)
    80003780:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003784:	bebff0ef          	jal	8000336e <filealloc>
    80003788:	e088                	sd	a0,0(s1)
    8000378a:	c549                	beqz	a0,80003814 <pipealloc+0xa8>
    8000378c:	be3ff0ef          	jal	8000336e <filealloc>
    80003790:	00aa3023          	sd	a0,0(s4)
    80003794:	cd25                	beqz	a0,8000380c <pipealloc+0xa0>
    80003796:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003798:	95ffc0ef          	jal	800000f6 <kalloc>
    8000379c:	892a                	mv	s2,a0
    8000379e:	c12d                	beqz	a0,80003800 <pipealloc+0x94>
    800037a0:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    800037a2:	4985                	li	s3,1
    800037a4:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800037a8:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800037ac:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800037b0:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800037b4:	00004597          	auipc	a1,0x4
    800037b8:	c4c58593          	addi	a1,a1,-948 # 80007400 <etext+0x400>
    800037bc:	054020ef          	jal	80005810 <initlock>
  (*f0)->type = FD_PIPE;
    800037c0:	609c                	ld	a5,0(s1)
    800037c2:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800037c6:	609c                	ld	a5,0(s1)
    800037c8:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800037cc:	609c                	ld	a5,0(s1)
    800037ce:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800037d2:	609c                	ld	a5,0(s1)
    800037d4:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800037d8:	000a3783          	ld	a5,0(s4)
    800037dc:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800037e0:	000a3783          	ld	a5,0(s4)
    800037e4:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800037e8:	000a3783          	ld	a5,0(s4)
    800037ec:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800037f0:	000a3783          	ld	a5,0(s4)
    800037f4:	0127b823          	sd	s2,16(a5)
  return 0;
    800037f8:	4501                	li	a0,0
    800037fa:	6942                	ld	s2,16(sp)
    800037fc:	69a2                	ld	s3,8(sp)
    800037fe:	a01d                	j	80003824 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003800:	6088                	ld	a0,0(s1)
    80003802:	c119                	beqz	a0,80003808 <pipealloc+0x9c>
    80003804:	6942                	ld	s2,16(sp)
    80003806:	a029                	j	80003810 <pipealloc+0xa4>
    80003808:	6942                	ld	s2,16(sp)
    8000380a:	a029                	j	80003814 <pipealloc+0xa8>
    8000380c:	6088                	ld	a0,0(s1)
    8000380e:	c10d                	beqz	a0,80003830 <pipealloc+0xc4>
    fileclose(*f0);
    80003810:	c03ff0ef          	jal	80003412 <fileclose>
  if(*f1)
    80003814:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003818:	557d                	li	a0,-1
  if(*f1)
    8000381a:	c789                	beqz	a5,80003824 <pipealloc+0xb8>
    fileclose(*f1);
    8000381c:	853e                	mv	a0,a5
    8000381e:	bf5ff0ef          	jal	80003412 <fileclose>
  return -1;
    80003822:	557d                	li	a0,-1
}
    80003824:	70a2                	ld	ra,40(sp)
    80003826:	7402                	ld	s0,32(sp)
    80003828:	64e2                	ld	s1,24(sp)
    8000382a:	6a02                	ld	s4,0(sp)
    8000382c:	6145                	addi	sp,sp,48
    8000382e:	8082                	ret
  return -1;
    80003830:	557d                	li	a0,-1
    80003832:	bfcd                	j	80003824 <pipealloc+0xb8>

0000000080003834 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003834:	1101                	addi	sp,sp,-32
    80003836:	ec06                	sd	ra,24(sp)
    80003838:	e822                	sd	s0,16(sp)
    8000383a:	e426                	sd	s1,8(sp)
    8000383c:	e04a                	sd	s2,0(sp)
    8000383e:	1000                	addi	s0,sp,32
    80003840:	84aa                	mv	s1,a0
    80003842:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003844:	04c020ef          	jal	80005890 <acquire>
  if(writable){
    80003848:	02090763          	beqz	s2,80003876 <pipeclose+0x42>
    pi->writeopen = 0;
    8000384c:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003850:	21848513          	addi	a0,s1,536
    80003854:	b5ffd0ef          	jal	800013b2 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003858:	2204b783          	ld	a5,544(s1)
    8000385c:	e785                	bnez	a5,80003884 <pipeclose+0x50>
    release(&pi->lock);
    8000385e:	8526                	mv	a0,s1
    80003860:	0c8020ef          	jal	80005928 <release>
    kfree((char*)pi);
    80003864:	8526                	mv	a0,s1
    80003866:	fb6fc0ef          	jal	8000001c <kfree>
  } else
    release(&pi->lock);
}
    8000386a:	60e2                	ld	ra,24(sp)
    8000386c:	6442                	ld	s0,16(sp)
    8000386e:	64a2                	ld	s1,8(sp)
    80003870:	6902                	ld	s2,0(sp)
    80003872:	6105                	addi	sp,sp,32
    80003874:	8082                	ret
    pi->readopen = 0;
    80003876:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000387a:	21c48513          	addi	a0,s1,540
    8000387e:	b35fd0ef          	jal	800013b2 <wakeup>
    80003882:	bfd9                	j	80003858 <pipeclose+0x24>
    release(&pi->lock);
    80003884:	8526                	mv	a0,s1
    80003886:	0a2020ef          	jal	80005928 <release>
}
    8000388a:	b7c5                	j	8000386a <pipeclose+0x36>

000000008000388c <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    8000388c:	711d                	addi	sp,sp,-96
    8000388e:	ec86                	sd	ra,88(sp)
    80003890:	e8a2                	sd	s0,80(sp)
    80003892:	e4a6                	sd	s1,72(sp)
    80003894:	e0ca                	sd	s2,64(sp)
    80003896:	fc4e                	sd	s3,56(sp)
    80003898:	f852                	sd	s4,48(sp)
    8000389a:	f456                	sd	s5,40(sp)
    8000389c:	1080                	addi	s0,sp,96
    8000389e:	84aa                	mv	s1,a0
    800038a0:	8aae                	mv	s5,a1
    800038a2:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800038a4:	cf4fd0ef          	jal	80000d98 <myproc>
    800038a8:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800038aa:	8526                	mv	a0,s1
    800038ac:	7e5010ef          	jal	80005890 <acquire>
  while(i < n){
    800038b0:	0b405a63          	blez	s4,80003964 <pipewrite+0xd8>
    800038b4:	f05a                	sd	s6,32(sp)
    800038b6:	ec5e                	sd	s7,24(sp)
    800038b8:	e862                	sd	s8,16(sp)
  int i = 0;
    800038ba:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800038bc:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800038be:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800038c2:	21c48b93          	addi	s7,s1,540
    800038c6:	a81d                	j	800038fc <pipewrite+0x70>
      release(&pi->lock);
    800038c8:	8526                	mv	a0,s1
    800038ca:	05e020ef          	jal	80005928 <release>
      return -1;
    800038ce:	597d                	li	s2,-1
    800038d0:	7b02                	ld	s6,32(sp)
    800038d2:	6be2                	ld	s7,24(sp)
    800038d4:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800038d6:	854a                	mv	a0,s2
    800038d8:	60e6                	ld	ra,88(sp)
    800038da:	6446                	ld	s0,80(sp)
    800038dc:	64a6                	ld	s1,72(sp)
    800038de:	6906                	ld	s2,64(sp)
    800038e0:	79e2                	ld	s3,56(sp)
    800038e2:	7a42                	ld	s4,48(sp)
    800038e4:	7aa2                	ld	s5,40(sp)
    800038e6:	6125                	addi	sp,sp,96
    800038e8:	8082                	ret
      wakeup(&pi->nread);
    800038ea:	8562                	mv	a0,s8
    800038ec:	ac7fd0ef          	jal	800013b2 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800038f0:	85a6                	mv	a1,s1
    800038f2:	855e                	mv	a0,s7
    800038f4:	a73fd0ef          	jal	80001366 <sleep>
  while(i < n){
    800038f8:	05495b63          	bge	s2,s4,8000394e <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    800038fc:	2204a783          	lw	a5,544(s1)
    80003900:	d7e1                	beqz	a5,800038c8 <pipewrite+0x3c>
    80003902:	854e                	mv	a0,s3
    80003904:	c9bfd0ef          	jal	8000159e <killed>
    80003908:	f161                	bnez	a0,800038c8 <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000390a:	2184a783          	lw	a5,536(s1)
    8000390e:	21c4a703          	lw	a4,540(s1)
    80003912:	2007879b          	addiw	a5,a5,512
    80003916:	fcf70ae3          	beq	a4,a5,800038ea <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000391a:	4685                	li	a3,1
    8000391c:	01590633          	add	a2,s2,s5
    80003920:	faf40593          	addi	a1,s0,-81
    80003924:	0509b503          	ld	a0,80(s3)
    80003928:	9b8fd0ef          	jal	80000ae0 <copyin>
    8000392c:	03650e63          	beq	a0,s6,80003968 <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003930:	21c4a783          	lw	a5,540(s1)
    80003934:	0017871b          	addiw	a4,a5,1
    80003938:	20e4ae23          	sw	a4,540(s1)
    8000393c:	1ff7f793          	andi	a5,a5,511
    80003940:	97a6                	add	a5,a5,s1
    80003942:	faf44703          	lbu	a4,-81(s0)
    80003946:	00e78c23          	sb	a4,24(a5)
      i++;
    8000394a:	2905                	addiw	s2,s2,1
    8000394c:	b775                	j	800038f8 <pipewrite+0x6c>
    8000394e:	7b02                	ld	s6,32(sp)
    80003950:	6be2                	ld	s7,24(sp)
    80003952:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80003954:	21848513          	addi	a0,s1,536
    80003958:	a5bfd0ef          	jal	800013b2 <wakeup>
  release(&pi->lock);
    8000395c:	8526                	mv	a0,s1
    8000395e:	7cb010ef          	jal	80005928 <release>
  return i;
    80003962:	bf95                	j	800038d6 <pipewrite+0x4a>
  int i = 0;
    80003964:	4901                	li	s2,0
    80003966:	b7fd                	j	80003954 <pipewrite+0xc8>
    80003968:	7b02                	ld	s6,32(sp)
    8000396a:	6be2                	ld	s7,24(sp)
    8000396c:	6c42                	ld	s8,16(sp)
    8000396e:	b7dd                	j	80003954 <pipewrite+0xc8>

0000000080003970 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003970:	715d                	addi	sp,sp,-80
    80003972:	e486                	sd	ra,72(sp)
    80003974:	e0a2                	sd	s0,64(sp)
    80003976:	fc26                	sd	s1,56(sp)
    80003978:	f84a                	sd	s2,48(sp)
    8000397a:	f44e                	sd	s3,40(sp)
    8000397c:	f052                	sd	s4,32(sp)
    8000397e:	ec56                	sd	s5,24(sp)
    80003980:	0880                	addi	s0,sp,80
    80003982:	84aa                	mv	s1,a0
    80003984:	892e                	mv	s2,a1
    80003986:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003988:	c10fd0ef          	jal	80000d98 <myproc>
    8000398c:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000398e:	8526                	mv	a0,s1
    80003990:	701010ef          	jal	80005890 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003994:	2184a703          	lw	a4,536(s1)
    80003998:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000399c:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800039a0:	02f71563          	bne	a4,a5,800039ca <piperead+0x5a>
    800039a4:	2244a783          	lw	a5,548(s1)
    800039a8:	cb85                	beqz	a5,800039d8 <piperead+0x68>
    if(killed(pr)){
    800039aa:	8552                	mv	a0,s4
    800039ac:	bf3fd0ef          	jal	8000159e <killed>
    800039b0:	ed19                	bnez	a0,800039ce <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800039b2:	85a6                	mv	a1,s1
    800039b4:	854e                	mv	a0,s3
    800039b6:	9b1fd0ef          	jal	80001366 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800039ba:	2184a703          	lw	a4,536(s1)
    800039be:	21c4a783          	lw	a5,540(s1)
    800039c2:	fef701e3          	beq	a4,a5,800039a4 <piperead+0x34>
    800039c6:	e85a                	sd	s6,16(sp)
    800039c8:	a809                	j	800039da <piperead+0x6a>
    800039ca:	e85a                	sd	s6,16(sp)
    800039cc:	a039                	j	800039da <piperead+0x6a>
      release(&pi->lock);
    800039ce:	8526                	mv	a0,s1
    800039d0:	759010ef          	jal	80005928 <release>
      return -1;
    800039d4:	59fd                	li	s3,-1
    800039d6:	a8b1                	j	80003a32 <piperead+0xc2>
    800039d8:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800039da:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800039dc:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800039de:	05505263          	blez	s5,80003a22 <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    800039e2:	2184a783          	lw	a5,536(s1)
    800039e6:	21c4a703          	lw	a4,540(s1)
    800039ea:	02f70c63          	beq	a4,a5,80003a22 <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800039ee:	0017871b          	addiw	a4,a5,1
    800039f2:	20e4ac23          	sw	a4,536(s1)
    800039f6:	1ff7f793          	andi	a5,a5,511
    800039fa:	97a6                	add	a5,a5,s1
    800039fc:	0187c783          	lbu	a5,24(a5)
    80003a00:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003a04:	4685                	li	a3,1
    80003a06:	fbf40613          	addi	a2,s0,-65
    80003a0a:	85ca                	mv	a1,s2
    80003a0c:	050a3503          	ld	a0,80(s4)
    80003a10:	ff9fc0ef          	jal	80000a08 <copyout>
    80003a14:	01650763          	beq	a0,s6,80003a22 <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003a18:	2985                	addiw	s3,s3,1
    80003a1a:	0905                	addi	s2,s2,1
    80003a1c:	fd3a93e3          	bne	s5,s3,800039e2 <piperead+0x72>
    80003a20:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003a22:	21c48513          	addi	a0,s1,540
    80003a26:	98dfd0ef          	jal	800013b2 <wakeup>
  release(&pi->lock);
    80003a2a:	8526                	mv	a0,s1
    80003a2c:	6fd010ef          	jal	80005928 <release>
    80003a30:	6b42                	ld	s6,16(sp)
  return i;
}
    80003a32:	854e                	mv	a0,s3
    80003a34:	60a6                	ld	ra,72(sp)
    80003a36:	6406                	ld	s0,64(sp)
    80003a38:	74e2                	ld	s1,56(sp)
    80003a3a:	7942                	ld	s2,48(sp)
    80003a3c:	79a2                	ld	s3,40(sp)
    80003a3e:	7a02                	ld	s4,32(sp)
    80003a40:	6ae2                	ld	s5,24(sp)
    80003a42:	6161                	addi	sp,sp,80
    80003a44:	8082                	ret

0000000080003a46 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80003a46:	1141                	addi	sp,sp,-16
    80003a48:	e422                	sd	s0,8(sp)
    80003a4a:	0800                	addi	s0,sp,16
    80003a4c:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80003a4e:	8905                	andi	a0,a0,1
    80003a50:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80003a52:	8b89                	andi	a5,a5,2
    80003a54:	c399                	beqz	a5,80003a5a <flags2perm+0x14>
      perm |= PTE_W;
    80003a56:	00456513          	ori	a0,a0,4
    return perm;
}
    80003a5a:	6422                	ld	s0,8(sp)
    80003a5c:	0141                	addi	sp,sp,16
    80003a5e:	8082                	ret

0000000080003a60 <exec>:

int
exec(char *path, char **argv)
{
    80003a60:	df010113          	addi	sp,sp,-528
    80003a64:	20113423          	sd	ra,520(sp)
    80003a68:	20813023          	sd	s0,512(sp)
    80003a6c:	ffa6                	sd	s1,504(sp)
    80003a6e:	fbca                	sd	s2,496(sp)
    80003a70:	0c00                	addi	s0,sp,528
    80003a72:	892a                	mv	s2,a0
    80003a74:	dea43c23          	sd	a0,-520(s0)
    80003a78:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003a7c:	b1cfd0ef          	jal	80000d98 <myproc>
    80003a80:	84aa                	mv	s1,a0

  begin_op();
    80003a82:	d76ff0ef          	jal	80002ff8 <begin_op>

  if((ip = namei(path)) == 0){
    80003a86:	854a                	mv	a0,s2
    80003a88:	bb4ff0ef          	jal	80002e3c <namei>
    80003a8c:	c931                	beqz	a0,80003ae0 <exec+0x80>
    80003a8e:	f3d2                	sd	s4,480(sp)
    80003a90:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80003a92:	cd1fe0ef          	jal	80002762 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80003a96:	04000713          	li	a4,64
    80003a9a:	4681                	li	a3,0
    80003a9c:	e5040613          	addi	a2,s0,-432
    80003aa0:	4581                	li	a1,0
    80003aa2:	8552                	mv	a0,s4
    80003aa4:	f13fe0ef          	jal	800029b6 <readi>
    80003aa8:	04000793          	li	a5,64
    80003aac:	00f51a63          	bne	a0,a5,80003ac0 <exec+0x60>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80003ab0:	e5042703          	lw	a4,-432(s0)
    80003ab4:	464c47b7          	lui	a5,0x464c4
    80003ab8:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003abc:	02f70663          	beq	a4,a5,80003ae8 <exec+0x88>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80003ac0:	8552                	mv	a0,s4
    80003ac2:	eabfe0ef          	jal	8000296c <iunlockput>
    end_op();
    80003ac6:	d9cff0ef          	jal	80003062 <end_op>
  }
  return -1;
    80003aca:	557d                	li	a0,-1
    80003acc:	7a1e                	ld	s4,480(sp)
}
    80003ace:	20813083          	ld	ra,520(sp)
    80003ad2:	20013403          	ld	s0,512(sp)
    80003ad6:	74fe                	ld	s1,504(sp)
    80003ad8:	795e                	ld	s2,496(sp)
    80003ada:	21010113          	addi	sp,sp,528
    80003ade:	8082                	ret
    end_op();
    80003ae0:	d82ff0ef          	jal	80003062 <end_op>
    return -1;
    80003ae4:	557d                	li	a0,-1
    80003ae6:	b7e5                	j	80003ace <exec+0x6e>
    80003ae8:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80003aea:	8526                	mv	a0,s1
    80003aec:	b54fd0ef          	jal	80000e40 <proc_pagetable>
    80003af0:	8b2a                	mv	s6,a0
    80003af2:	2c050b63          	beqz	a0,80003dc8 <exec+0x368>
    80003af6:	f7ce                	sd	s3,488(sp)
    80003af8:	efd6                	sd	s5,472(sp)
    80003afa:	e7de                	sd	s7,456(sp)
    80003afc:	e3e2                	sd	s8,448(sp)
    80003afe:	ff66                	sd	s9,440(sp)
    80003b00:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003b02:	e7042d03          	lw	s10,-400(s0)
    80003b06:	e8845783          	lhu	a5,-376(s0)
    80003b0a:	12078963          	beqz	a5,80003c3c <exec+0x1dc>
    80003b0e:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003b10:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003b12:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80003b14:	6c85                	lui	s9,0x1
    80003b16:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80003b1a:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80003b1e:	6a85                	lui	s5,0x1
    80003b20:	a085                	j	80003b80 <exec+0x120>
      panic("loadseg: address should exist");
    80003b22:	00004517          	auipc	a0,0x4
    80003b26:	b3e50513          	addi	a0,a0,-1218 # 80007660 <etext+0x660>
    80003b2a:	239010ef          	jal	80005562 <panic>
    if(sz - i < PGSIZE)
    80003b2e:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80003b30:	8726                	mv	a4,s1
    80003b32:	012c06bb          	addw	a3,s8,s2
    80003b36:	4581                	li	a1,0
    80003b38:	8552                	mv	a0,s4
    80003b3a:	e7dfe0ef          	jal	800029b6 <readi>
    80003b3e:	2501                	sext.w	a0,a0
    80003b40:	24a49a63          	bne	s1,a0,80003d94 <exec+0x334>
  for(i = 0; i < sz; i += PGSIZE){
    80003b44:	012a893b          	addw	s2,s5,s2
    80003b48:	03397363          	bgeu	s2,s3,80003b6e <exec+0x10e>
    pa = walkaddr(pagetable, va + i);
    80003b4c:	02091593          	slli	a1,s2,0x20
    80003b50:	9181                	srli	a1,a1,0x20
    80003b52:	95de                	add	a1,a1,s7
    80003b54:	855a                	mv	a0,s6
    80003b56:	92ffc0ef          	jal	80000484 <walkaddr>
    80003b5a:	862a                	mv	a2,a0
    if(pa == 0)
    80003b5c:	d179                	beqz	a0,80003b22 <exec+0xc2>
    if(sz - i < PGSIZE)
    80003b5e:	412984bb          	subw	s1,s3,s2
    80003b62:	0004879b          	sext.w	a5,s1
    80003b66:	fcfcf4e3          	bgeu	s9,a5,80003b2e <exec+0xce>
    80003b6a:	84d6                	mv	s1,s5
    80003b6c:	b7c9                	j	80003b2e <exec+0xce>
    sz = sz1;
    80003b6e:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003b72:	2d85                	addiw	s11,s11,1
    80003b74:	038d0d1b          	addiw	s10,s10,56
    80003b78:	e8845783          	lhu	a5,-376(s0)
    80003b7c:	08fdd063          	bge	s11,a5,80003bfc <exec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003b80:	2d01                	sext.w	s10,s10
    80003b82:	03800713          	li	a4,56
    80003b86:	86ea                	mv	a3,s10
    80003b88:	e1840613          	addi	a2,s0,-488
    80003b8c:	4581                	li	a1,0
    80003b8e:	8552                	mv	a0,s4
    80003b90:	e27fe0ef          	jal	800029b6 <readi>
    80003b94:	03800793          	li	a5,56
    80003b98:	1cf51663          	bne	a0,a5,80003d64 <exec+0x304>
    if(ph.type != ELF_PROG_LOAD)
    80003b9c:	e1842783          	lw	a5,-488(s0)
    80003ba0:	4705                	li	a4,1
    80003ba2:	fce798e3          	bne	a5,a4,80003b72 <exec+0x112>
    if(ph.memsz < ph.filesz)
    80003ba6:	e4043483          	ld	s1,-448(s0)
    80003baa:	e3843783          	ld	a5,-456(s0)
    80003bae:	1af4ef63          	bltu	s1,a5,80003d6c <exec+0x30c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003bb2:	e2843783          	ld	a5,-472(s0)
    80003bb6:	94be                	add	s1,s1,a5
    80003bb8:	1af4ee63          	bltu	s1,a5,80003d74 <exec+0x314>
    if(ph.vaddr % PGSIZE != 0)
    80003bbc:	df043703          	ld	a4,-528(s0)
    80003bc0:	8ff9                	and	a5,a5,a4
    80003bc2:	1a079d63          	bnez	a5,80003d7c <exec+0x31c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003bc6:	e1c42503          	lw	a0,-484(s0)
    80003bca:	e7dff0ef          	jal	80003a46 <flags2perm>
    80003bce:	86aa                	mv	a3,a0
    80003bd0:	8626                	mv	a2,s1
    80003bd2:	85ca                	mv	a1,s2
    80003bd4:	855a                	mv	a0,s6
    80003bd6:	c27fc0ef          	jal	800007fc <uvmalloc>
    80003bda:	e0a43423          	sd	a0,-504(s0)
    80003bde:	1a050363          	beqz	a0,80003d84 <exec+0x324>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003be2:	e2843b83          	ld	s7,-472(s0)
    80003be6:	e2042c03          	lw	s8,-480(s0)
    80003bea:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003bee:	00098463          	beqz	s3,80003bf6 <exec+0x196>
    80003bf2:	4901                	li	s2,0
    80003bf4:	bfa1                	j	80003b4c <exec+0xec>
    sz = sz1;
    80003bf6:	e0843903          	ld	s2,-504(s0)
    80003bfa:	bfa5                	j	80003b72 <exec+0x112>
    80003bfc:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80003bfe:	8552                	mv	a0,s4
    80003c00:	d6dfe0ef          	jal	8000296c <iunlockput>
  end_op();
    80003c04:	c5eff0ef          	jal	80003062 <end_op>
  p = myproc();
    80003c08:	990fd0ef          	jal	80000d98 <myproc>
    80003c0c:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80003c0e:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80003c12:	6985                	lui	s3,0x1
    80003c14:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80003c16:	99ca                	add	s3,s3,s2
    80003c18:	77fd                	lui	a5,0xfffff
    80003c1a:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003c1e:	4691                	li	a3,4
    80003c20:	6609                	lui	a2,0x2
    80003c22:	964e                	add	a2,a2,s3
    80003c24:	85ce                	mv	a1,s3
    80003c26:	855a                	mv	a0,s6
    80003c28:	bd5fc0ef          	jal	800007fc <uvmalloc>
    80003c2c:	892a                	mv	s2,a0
    80003c2e:	e0a43423          	sd	a0,-504(s0)
    80003c32:	e519                	bnez	a0,80003c40 <exec+0x1e0>
  if(pagetable)
    80003c34:	e1343423          	sd	s3,-504(s0)
    80003c38:	4a01                	li	s4,0
    80003c3a:	aab1                	j	80003d96 <exec+0x336>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003c3c:	4901                	li	s2,0
    80003c3e:	b7c1                	j	80003bfe <exec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003c40:	75f9                	lui	a1,0xffffe
    80003c42:	95aa                	add	a1,a1,a0
    80003c44:	855a                	mv	a0,s6
    80003c46:	d99fc0ef          	jal	800009de <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80003c4a:	7bfd                	lui	s7,0xfffff
    80003c4c:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80003c4e:	e0043783          	ld	a5,-512(s0)
    80003c52:	6388                	ld	a0,0(a5)
    80003c54:	cd39                	beqz	a0,80003cb2 <exec+0x252>
    80003c56:	e9040993          	addi	s3,s0,-368
    80003c5a:	f9040c13          	addi	s8,s0,-112
    80003c5e:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80003c60:	e86fc0ef          	jal	800002e6 <strlen>
    80003c64:	0015079b          	addiw	a5,a0,1
    80003c68:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003c6c:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80003c70:	11796e63          	bltu	s2,s7,80003d8c <exec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003c74:	e0043d03          	ld	s10,-512(s0)
    80003c78:	000d3a03          	ld	s4,0(s10)
    80003c7c:	8552                	mv	a0,s4
    80003c7e:	e68fc0ef          	jal	800002e6 <strlen>
    80003c82:	0015069b          	addiw	a3,a0,1
    80003c86:	8652                	mv	a2,s4
    80003c88:	85ca                	mv	a1,s2
    80003c8a:	855a                	mv	a0,s6
    80003c8c:	d7dfc0ef          	jal	80000a08 <copyout>
    80003c90:	10054063          	bltz	a0,80003d90 <exec+0x330>
    ustack[argc] = sp;
    80003c94:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80003c98:	0485                	addi	s1,s1,1
    80003c9a:	008d0793          	addi	a5,s10,8
    80003c9e:	e0f43023          	sd	a5,-512(s0)
    80003ca2:	008d3503          	ld	a0,8(s10)
    80003ca6:	c909                	beqz	a0,80003cb8 <exec+0x258>
    if(argc >= MAXARG)
    80003ca8:	09a1                	addi	s3,s3,8
    80003caa:	fb899be3          	bne	s3,s8,80003c60 <exec+0x200>
  ip = 0;
    80003cae:	4a01                	li	s4,0
    80003cb0:	a0dd                	j	80003d96 <exec+0x336>
  sp = sz;
    80003cb2:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80003cb6:	4481                	li	s1,0
  ustack[argc] = 0;
    80003cb8:	00349793          	slli	a5,s1,0x3
    80003cbc:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdb7e0>
    80003cc0:	97a2                	add	a5,a5,s0
    80003cc2:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80003cc6:	00148693          	addi	a3,s1,1
    80003cca:	068e                	slli	a3,a3,0x3
    80003ccc:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003cd0:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80003cd4:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80003cd8:	f5796ee3          	bltu	s2,s7,80003c34 <exec+0x1d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003cdc:	e9040613          	addi	a2,s0,-368
    80003ce0:	85ca                	mv	a1,s2
    80003ce2:	855a                	mv	a0,s6
    80003ce4:	d25fc0ef          	jal	80000a08 <copyout>
    80003ce8:	0e054263          	bltz	a0,80003dcc <exec+0x36c>
  p->trapframe->a1 = sp;
    80003cec:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80003cf0:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80003cf4:	df843783          	ld	a5,-520(s0)
    80003cf8:	0007c703          	lbu	a4,0(a5)
    80003cfc:	cf11                	beqz	a4,80003d18 <exec+0x2b8>
    80003cfe:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003d00:	02f00693          	li	a3,47
    80003d04:	a039                	j	80003d12 <exec+0x2b2>
      last = s+1;
    80003d06:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80003d0a:	0785                	addi	a5,a5,1
    80003d0c:	fff7c703          	lbu	a4,-1(a5)
    80003d10:	c701                	beqz	a4,80003d18 <exec+0x2b8>
    if(*s == '/')
    80003d12:	fed71ce3          	bne	a4,a3,80003d0a <exec+0x2aa>
    80003d16:	bfc5                	j	80003d06 <exec+0x2a6>
  safestrcpy(p->name, last, sizeof(p->name));
    80003d18:	4641                	li	a2,16
    80003d1a:	df843583          	ld	a1,-520(s0)
    80003d1e:	158a8513          	addi	a0,s5,344
    80003d22:	d92fc0ef          	jal	800002b4 <safestrcpy>
  oldpagetable = p->pagetable;
    80003d26:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80003d2a:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80003d2e:	e0843783          	ld	a5,-504(s0)
    80003d32:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80003d36:	058ab783          	ld	a5,88(s5)
    80003d3a:	e6843703          	ld	a4,-408(s0)
    80003d3e:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80003d40:	058ab783          	ld	a5,88(s5)
    80003d44:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80003d48:	85e6                	mv	a1,s9
    80003d4a:	97afd0ef          	jal	80000ec4 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80003d4e:	0004851b          	sext.w	a0,s1
    80003d52:	79be                	ld	s3,488(sp)
    80003d54:	7a1e                	ld	s4,480(sp)
    80003d56:	6afe                	ld	s5,472(sp)
    80003d58:	6b5e                	ld	s6,464(sp)
    80003d5a:	6bbe                	ld	s7,456(sp)
    80003d5c:	6c1e                	ld	s8,448(sp)
    80003d5e:	7cfa                	ld	s9,440(sp)
    80003d60:	7d5a                	ld	s10,432(sp)
    80003d62:	b3b5                	j	80003ace <exec+0x6e>
    80003d64:	e1243423          	sd	s2,-504(s0)
    80003d68:	7dba                	ld	s11,424(sp)
    80003d6a:	a035                	j	80003d96 <exec+0x336>
    80003d6c:	e1243423          	sd	s2,-504(s0)
    80003d70:	7dba                	ld	s11,424(sp)
    80003d72:	a015                	j	80003d96 <exec+0x336>
    80003d74:	e1243423          	sd	s2,-504(s0)
    80003d78:	7dba                	ld	s11,424(sp)
    80003d7a:	a831                	j	80003d96 <exec+0x336>
    80003d7c:	e1243423          	sd	s2,-504(s0)
    80003d80:	7dba                	ld	s11,424(sp)
    80003d82:	a811                	j	80003d96 <exec+0x336>
    80003d84:	e1243423          	sd	s2,-504(s0)
    80003d88:	7dba                	ld	s11,424(sp)
    80003d8a:	a031                	j	80003d96 <exec+0x336>
  ip = 0;
    80003d8c:	4a01                	li	s4,0
    80003d8e:	a021                	j	80003d96 <exec+0x336>
    80003d90:	4a01                	li	s4,0
  if(pagetable)
    80003d92:	a011                	j	80003d96 <exec+0x336>
    80003d94:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80003d96:	e0843583          	ld	a1,-504(s0)
    80003d9a:	855a                	mv	a0,s6
    80003d9c:	928fd0ef          	jal	80000ec4 <proc_freepagetable>
  return -1;
    80003da0:	557d                	li	a0,-1
  if(ip){
    80003da2:	000a1b63          	bnez	s4,80003db8 <exec+0x358>
    80003da6:	79be                	ld	s3,488(sp)
    80003da8:	7a1e                	ld	s4,480(sp)
    80003daa:	6afe                	ld	s5,472(sp)
    80003dac:	6b5e                	ld	s6,464(sp)
    80003dae:	6bbe                	ld	s7,456(sp)
    80003db0:	6c1e                	ld	s8,448(sp)
    80003db2:	7cfa                	ld	s9,440(sp)
    80003db4:	7d5a                	ld	s10,432(sp)
    80003db6:	bb21                	j	80003ace <exec+0x6e>
    80003db8:	79be                	ld	s3,488(sp)
    80003dba:	6afe                	ld	s5,472(sp)
    80003dbc:	6b5e                	ld	s6,464(sp)
    80003dbe:	6bbe                	ld	s7,456(sp)
    80003dc0:	6c1e                	ld	s8,448(sp)
    80003dc2:	7cfa                	ld	s9,440(sp)
    80003dc4:	7d5a                	ld	s10,432(sp)
    80003dc6:	b9ed                	j	80003ac0 <exec+0x60>
    80003dc8:	6b5e                	ld	s6,464(sp)
    80003dca:	b9dd                	j	80003ac0 <exec+0x60>
  sz = sz1;
    80003dcc:	e0843983          	ld	s3,-504(s0)
    80003dd0:	b595                	j	80003c34 <exec+0x1d4>

0000000080003dd2 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80003dd2:	7179                	addi	sp,sp,-48
    80003dd4:	f406                	sd	ra,40(sp)
    80003dd6:	f022                	sd	s0,32(sp)
    80003dd8:	ec26                	sd	s1,24(sp)
    80003dda:	e84a                	sd	s2,16(sp)
    80003ddc:	1800                	addi	s0,sp,48
    80003dde:	892e                	mv	s2,a1
    80003de0:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80003de2:	fdc40593          	addi	a1,s0,-36
    80003de6:	eb3fd0ef          	jal	80001c98 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80003dea:	fdc42703          	lw	a4,-36(s0)
    80003dee:	47bd                	li	a5,15
    80003df0:	02e7e963          	bltu	a5,a4,80003e22 <argfd+0x50>
    80003df4:	fa5fc0ef          	jal	80000d98 <myproc>
    80003df8:	fdc42703          	lw	a4,-36(s0)
    80003dfc:	01a70793          	addi	a5,a4,26
    80003e00:	078e                	slli	a5,a5,0x3
    80003e02:	953e                	add	a0,a0,a5
    80003e04:	611c                	ld	a5,0(a0)
    80003e06:	c385                	beqz	a5,80003e26 <argfd+0x54>
    return -1;
  if(pfd)
    80003e08:	00090463          	beqz	s2,80003e10 <argfd+0x3e>
    *pfd = fd;
    80003e0c:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80003e10:	4501                	li	a0,0
  if(pf)
    80003e12:	c091                	beqz	s1,80003e16 <argfd+0x44>
    *pf = f;
    80003e14:	e09c                	sd	a5,0(s1)
}
    80003e16:	70a2                	ld	ra,40(sp)
    80003e18:	7402                	ld	s0,32(sp)
    80003e1a:	64e2                	ld	s1,24(sp)
    80003e1c:	6942                	ld	s2,16(sp)
    80003e1e:	6145                	addi	sp,sp,48
    80003e20:	8082                	ret
    return -1;
    80003e22:	557d                	li	a0,-1
    80003e24:	bfcd                	j	80003e16 <argfd+0x44>
    80003e26:	557d                	li	a0,-1
    80003e28:	b7fd                	j	80003e16 <argfd+0x44>

0000000080003e2a <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80003e2a:	1101                	addi	sp,sp,-32
    80003e2c:	ec06                	sd	ra,24(sp)
    80003e2e:	e822                	sd	s0,16(sp)
    80003e30:	e426                	sd	s1,8(sp)
    80003e32:	1000                	addi	s0,sp,32
    80003e34:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80003e36:	f63fc0ef          	jal	80000d98 <myproc>
    80003e3a:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80003e3c:	0d050793          	addi	a5,a0,208
    80003e40:	4501                	li	a0,0
    80003e42:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80003e44:	6398                	ld	a4,0(a5)
    80003e46:	cb19                	beqz	a4,80003e5c <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80003e48:	2505                	addiw	a0,a0,1
    80003e4a:	07a1                	addi	a5,a5,8
    80003e4c:	fed51ce3          	bne	a0,a3,80003e44 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80003e50:	557d                	li	a0,-1
}
    80003e52:	60e2                	ld	ra,24(sp)
    80003e54:	6442                	ld	s0,16(sp)
    80003e56:	64a2                	ld	s1,8(sp)
    80003e58:	6105                	addi	sp,sp,32
    80003e5a:	8082                	ret
      p->ofile[fd] = f;
    80003e5c:	01a50793          	addi	a5,a0,26
    80003e60:	078e                	slli	a5,a5,0x3
    80003e62:	963e                	add	a2,a2,a5
    80003e64:	e204                	sd	s1,0(a2)
      return fd;
    80003e66:	b7f5                	j	80003e52 <fdalloc+0x28>

0000000080003e68 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80003e68:	715d                	addi	sp,sp,-80
    80003e6a:	e486                	sd	ra,72(sp)
    80003e6c:	e0a2                	sd	s0,64(sp)
    80003e6e:	fc26                	sd	s1,56(sp)
    80003e70:	f84a                	sd	s2,48(sp)
    80003e72:	f44e                	sd	s3,40(sp)
    80003e74:	ec56                	sd	s5,24(sp)
    80003e76:	e85a                	sd	s6,16(sp)
    80003e78:	0880                	addi	s0,sp,80
    80003e7a:	8b2e                	mv	s6,a1
    80003e7c:	89b2                	mv	s3,a2
    80003e7e:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80003e80:	fb040593          	addi	a1,s0,-80
    80003e84:	fd3fe0ef          	jal	80002e56 <nameiparent>
    80003e88:	84aa                	mv	s1,a0
    80003e8a:	10050a63          	beqz	a0,80003f9e <create+0x136>
    return 0;

  ilock(dp);
    80003e8e:	8d5fe0ef          	jal	80002762 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80003e92:	4601                	li	a2,0
    80003e94:	fb040593          	addi	a1,s0,-80
    80003e98:	8526                	mv	a0,s1
    80003e9a:	d3dfe0ef          	jal	80002bd6 <dirlookup>
    80003e9e:	8aaa                	mv	s5,a0
    80003ea0:	c129                	beqz	a0,80003ee2 <create+0x7a>
    iunlockput(dp);
    80003ea2:	8526                	mv	a0,s1
    80003ea4:	ac9fe0ef          	jal	8000296c <iunlockput>
    ilock(ip);
    80003ea8:	8556                	mv	a0,s5
    80003eaa:	8b9fe0ef          	jal	80002762 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80003eae:	4789                	li	a5,2
    80003eb0:	02fb1463          	bne	s6,a5,80003ed8 <create+0x70>
    80003eb4:	044ad783          	lhu	a5,68(s5)
    80003eb8:	37f9                	addiw	a5,a5,-2
    80003eba:	17c2                	slli	a5,a5,0x30
    80003ebc:	93c1                	srli	a5,a5,0x30
    80003ebe:	4705                	li	a4,1
    80003ec0:	00f76c63          	bltu	a4,a5,80003ed8 <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80003ec4:	8556                	mv	a0,s5
    80003ec6:	60a6                	ld	ra,72(sp)
    80003ec8:	6406                	ld	s0,64(sp)
    80003eca:	74e2                	ld	s1,56(sp)
    80003ecc:	7942                	ld	s2,48(sp)
    80003ece:	79a2                	ld	s3,40(sp)
    80003ed0:	6ae2                	ld	s5,24(sp)
    80003ed2:	6b42                	ld	s6,16(sp)
    80003ed4:	6161                	addi	sp,sp,80
    80003ed6:	8082                	ret
    iunlockput(ip);
    80003ed8:	8556                	mv	a0,s5
    80003eda:	a93fe0ef          	jal	8000296c <iunlockput>
    return 0;
    80003ede:	4a81                	li	s5,0
    80003ee0:	b7d5                	j	80003ec4 <create+0x5c>
    80003ee2:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80003ee4:	85da                	mv	a1,s6
    80003ee6:	4088                	lw	a0,0(s1)
    80003ee8:	f0afe0ef          	jal	800025f2 <ialloc>
    80003eec:	8a2a                	mv	s4,a0
    80003eee:	cd15                	beqz	a0,80003f2a <create+0xc2>
  ilock(ip);
    80003ef0:	873fe0ef          	jal	80002762 <ilock>
  ip->major = major;
    80003ef4:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80003ef8:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80003efc:	4905                	li	s2,1
    80003efe:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80003f02:	8552                	mv	a0,s4
    80003f04:	faafe0ef          	jal	800026ae <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80003f08:	032b0763          	beq	s6,s2,80003f36 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80003f0c:	004a2603          	lw	a2,4(s4)
    80003f10:	fb040593          	addi	a1,s0,-80
    80003f14:	8526                	mv	a0,s1
    80003f16:	e8dfe0ef          	jal	80002da2 <dirlink>
    80003f1a:	06054563          	bltz	a0,80003f84 <create+0x11c>
  iunlockput(dp);
    80003f1e:	8526                	mv	a0,s1
    80003f20:	a4dfe0ef          	jal	8000296c <iunlockput>
  return ip;
    80003f24:	8ad2                	mv	s5,s4
    80003f26:	7a02                	ld	s4,32(sp)
    80003f28:	bf71                	j	80003ec4 <create+0x5c>
    iunlockput(dp);
    80003f2a:	8526                	mv	a0,s1
    80003f2c:	a41fe0ef          	jal	8000296c <iunlockput>
    return 0;
    80003f30:	8ad2                	mv	s5,s4
    80003f32:	7a02                	ld	s4,32(sp)
    80003f34:	bf41                	j	80003ec4 <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80003f36:	004a2603          	lw	a2,4(s4)
    80003f3a:	00003597          	auipc	a1,0x3
    80003f3e:	74658593          	addi	a1,a1,1862 # 80007680 <etext+0x680>
    80003f42:	8552                	mv	a0,s4
    80003f44:	e5ffe0ef          	jal	80002da2 <dirlink>
    80003f48:	02054e63          	bltz	a0,80003f84 <create+0x11c>
    80003f4c:	40d0                	lw	a2,4(s1)
    80003f4e:	00003597          	auipc	a1,0x3
    80003f52:	73a58593          	addi	a1,a1,1850 # 80007688 <etext+0x688>
    80003f56:	8552                	mv	a0,s4
    80003f58:	e4bfe0ef          	jal	80002da2 <dirlink>
    80003f5c:	02054463          	bltz	a0,80003f84 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80003f60:	004a2603          	lw	a2,4(s4)
    80003f64:	fb040593          	addi	a1,s0,-80
    80003f68:	8526                	mv	a0,s1
    80003f6a:	e39fe0ef          	jal	80002da2 <dirlink>
    80003f6e:	00054b63          	bltz	a0,80003f84 <create+0x11c>
    dp->nlink++;  // for ".."
    80003f72:	04a4d783          	lhu	a5,74(s1)
    80003f76:	2785                	addiw	a5,a5,1
    80003f78:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80003f7c:	8526                	mv	a0,s1
    80003f7e:	f30fe0ef          	jal	800026ae <iupdate>
    80003f82:	bf71                	j	80003f1e <create+0xb6>
  ip->nlink = 0;
    80003f84:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80003f88:	8552                	mv	a0,s4
    80003f8a:	f24fe0ef          	jal	800026ae <iupdate>
  iunlockput(ip);
    80003f8e:	8552                	mv	a0,s4
    80003f90:	9ddfe0ef          	jal	8000296c <iunlockput>
  iunlockput(dp);
    80003f94:	8526                	mv	a0,s1
    80003f96:	9d7fe0ef          	jal	8000296c <iunlockput>
  return 0;
    80003f9a:	7a02                	ld	s4,32(sp)
    80003f9c:	b725                	j	80003ec4 <create+0x5c>
    return 0;
    80003f9e:	8aaa                	mv	s5,a0
    80003fa0:	b715                	j	80003ec4 <create+0x5c>

0000000080003fa2 <sys_dup>:
{
    80003fa2:	7179                	addi	sp,sp,-48
    80003fa4:	f406                	sd	ra,40(sp)
    80003fa6:	f022                	sd	s0,32(sp)
    80003fa8:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80003faa:	fd840613          	addi	a2,s0,-40
    80003fae:	4581                	li	a1,0
    80003fb0:	4501                	li	a0,0
    80003fb2:	e21ff0ef          	jal	80003dd2 <argfd>
    return -1;
    80003fb6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80003fb8:	02054363          	bltz	a0,80003fde <sys_dup+0x3c>
    80003fbc:	ec26                	sd	s1,24(sp)
    80003fbe:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80003fc0:	fd843903          	ld	s2,-40(s0)
    80003fc4:	854a                	mv	a0,s2
    80003fc6:	e65ff0ef          	jal	80003e2a <fdalloc>
    80003fca:	84aa                	mv	s1,a0
    return -1;
    80003fcc:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80003fce:	00054d63          	bltz	a0,80003fe8 <sys_dup+0x46>
  filedup(f);
    80003fd2:	854a                	mv	a0,s2
    80003fd4:	bf8ff0ef          	jal	800033cc <filedup>
  return fd;
    80003fd8:	87a6                	mv	a5,s1
    80003fda:	64e2                	ld	s1,24(sp)
    80003fdc:	6942                	ld	s2,16(sp)
}
    80003fde:	853e                	mv	a0,a5
    80003fe0:	70a2                	ld	ra,40(sp)
    80003fe2:	7402                	ld	s0,32(sp)
    80003fe4:	6145                	addi	sp,sp,48
    80003fe6:	8082                	ret
    80003fe8:	64e2                	ld	s1,24(sp)
    80003fea:	6942                	ld	s2,16(sp)
    80003fec:	bfcd                	j	80003fde <sys_dup+0x3c>

0000000080003fee <sys_read>:
{
    80003fee:	7179                	addi	sp,sp,-48
    80003ff0:	f406                	sd	ra,40(sp)
    80003ff2:	f022                	sd	s0,32(sp)
    80003ff4:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80003ff6:	fd840593          	addi	a1,s0,-40
    80003ffa:	4505                	li	a0,1
    80003ffc:	cb9fd0ef          	jal	80001cb4 <argaddr>
  argint(2, &n);
    80004000:	fe440593          	addi	a1,s0,-28
    80004004:	4509                	li	a0,2
    80004006:	c93fd0ef          	jal	80001c98 <argint>
  if(argfd(0, 0, &f) < 0)
    8000400a:	fe840613          	addi	a2,s0,-24
    8000400e:	4581                	li	a1,0
    80004010:	4501                	li	a0,0
    80004012:	dc1ff0ef          	jal	80003dd2 <argfd>
    80004016:	87aa                	mv	a5,a0
    return -1;
    80004018:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000401a:	0007ca63          	bltz	a5,8000402e <sys_read+0x40>
  return fileread(f, p, n);
    8000401e:	fe442603          	lw	a2,-28(s0)
    80004022:	fd843583          	ld	a1,-40(s0)
    80004026:	fe843503          	ld	a0,-24(s0)
    8000402a:	d08ff0ef          	jal	80003532 <fileread>
}
    8000402e:	70a2                	ld	ra,40(sp)
    80004030:	7402                	ld	s0,32(sp)
    80004032:	6145                	addi	sp,sp,48
    80004034:	8082                	ret

0000000080004036 <sys_write>:
{
    80004036:	7179                	addi	sp,sp,-48
    80004038:	f406                	sd	ra,40(sp)
    8000403a:	f022                	sd	s0,32(sp)
    8000403c:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000403e:	fd840593          	addi	a1,s0,-40
    80004042:	4505                	li	a0,1
    80004044:	c71fd0ef          	jal	80001cb4 <argaddr>
  argint(2, &n);
    80004048:	fe440593          	addi	a1,s0,-28
    8000404c:	4509                	li	a0,2
    8000404e:	c4bfd0ef          	jal	80001c98 <argint>
  if(argfd(0, 0, &f) < 0)
    80004052:	fe840613          	addi	a2,s0,-24
    80004056:	4581                	li	a1,0
    80004058:	4501                	li	a0,0
    8000405a:	d79ff0ef          	jal	80003dd2 <argfd>
    8000405e:	87aa                	mv	a5,a0
    return -1;
    80004060:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004062:	0007ca63          	bltz	a5,80004076 <sys_write+0x40>
  return filewrite(f, p, n);
    80004066:	fe442603          	lw	a2,-28(s0)
    8000406a:	fd843583          	ld	a1,-40(s0)
    8000406e:	fe843503          	ld	a0,-24(s0)
    80004072:	d7eff0ef          	jal	800035f0 <filewrite>
}
    80004076:	70a2                	ld	ra,40(sp)
    80004078:	7402                	ld	s0,32(sp)
    8000407a:	6145                	addi	sp,sp,48
    8000407c:	8082                	ret

000000008000407e <sys_close>:
{
    8000407e:	1101                	addi	sp,sp,-32
    80004080:	ec06                	sd	ra,24(sp)
    80004082:	e822                	sd	s0,16(sp)
    80004084:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004086:	fe040613          	addi	a2,s0,-32
    8000408a:	fec40593          	addi	a1,s0,-20
    8000408e:	4501                	li	a0,0
    80004090:	d43ff0ef          	jal	80003dd2 <argfd>
    return -1;
    80004094:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004096:	02054063          	bltz	a0,800040b6 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    8000409a:	cfffc0ef          	jal	80000d98 <myproc>
    8000409e:	fec42783          	lw	a5,-20(s0)
    800040a2:	07e9                	addi	a5,a5,26
    800040a4:	078e                	slli	a5,a5,0x3
    800040a6:	953e                	add	a0,a0,a5
    800040a8:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800040ac:	fe043503          	ld	a0,-32(s0)
    800040b0:	b62ff0ef          	jal	80003412 <fileclose>
  return 0;
    800040b4:	4781                	li	a5,0
}
    800040b6:	853e                	mv	a0,a5
    800040b8:	60e2                	ld	ra,24(sp)
    800040ba:	6442                	ld	s0,16(sp)
    800040bc:	6105                	addi	sp,sp,32
    800040be:	8082                	ret

00000000800040c0 <sys_fstat>:
{
    800040c0:	1101                	addi	sp,sp,-32
    800040c2:	ec06                	sd	ra,24(sp)
    800040c4:	e822                	sd	s0,16(sp)
    800040c6:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800040c8:	fe040593          	addi	a1,s0,-32
    800040cc:	4505                	li	a0,1
    800040ce:	be7fd0ef          	jal	80001cb4 <argaddr>
  if(argfd(0, 0, &f) < 0)
    800040d2:	fe840613          	addi	a2,s0,-24
    800040d6:	4581                	li	a1,0
    800040d8:	4501                	li	a0,0
    800040da:	cf9ff0ef          	jal	80003dd2 <argfd>
    800040de:	87aa                	mv	a5,a0
    return -1;
    800040e0:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800040e2:	0007c863          	bltz	a5,800040f2 <sys_fstat+0x32>
  return filestat(f, st);
    800040e6:	fe043583          	ld	a1,-32(s0)
    800040ea:	fe843503          	ld	a0,-24(s0)
    800040ee:	be6ff0ef          	jal	800034d4 <filestat>
}
    800040f2:	60e2                	ld	ra,24(sp)
    800040f4:	6442                	ld	s0,16(sp)
    800040f6:	6105                	addi	sp,sp,32
    800040f8:	8082                	ret

00000000800040fa <sys_link>:
{
    800040fa:	7169                	addi	sp,sp,-304
    800040fc:	f606                	sd	ra,296(sp)
    800040fe:	f222                	sd	s0,288(sp)
    80004100:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004102:	08000613          	li	a2,128
    80004106:	ed040593          	addi	a1,s0,-304
    8000410a:	4501                	li	a0,0
    8000410c:	bc5fd0ef          	jal	80001cd0 <argstr>
    return -1;
    80004110:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004112:	0c054e63          	bltz	a0,800041ee <sys_link+0xf4>
    80004116:	08000613          	li	a2,128
    8000411a:	f5040593          	addi	a1,s0,-176
    8000411e:	4505                	li	a0,1
    80004120:	bb1fd0ef          	jal	80001cd0 <argstr>
    return -1;
    80004124:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004126:	0c054463          	bltz	a0,800041ee <sys_link+0xf4>
    8000412a:	ee26                	sd	s1,280(sp)
  begin_op();
    8000412c:	ecdfe0ef          	jal	80002ff8 <begin_op>
  if((ip = namei(old)) == 0){
    80004130:	ed040513          	addi	a0,s0,-304
    80004134:	d09fe0ef          	jal	80002e3c <namei>
    80004138:	84aa                	mv	s1,a0
    8000413a:	c53d                	beqz	a0,800041a8 <sys_link+0xae>
  ilock(ip);
    8000413c:	e26fe0ef          	jal	80002762 <ilock>
  if(ip->type == T_DIR){
    80004140:	04449703          	lh	a4,68(s1)
    80004144:	4785                	li	a5,1
    80004146:	06f70663          	beq	a4,a5,800041b2 <sys_link+0xb8>
    8000414a:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    8000414c:	04a4d783          	lhu	a5,74(s1)
    80004150:	2785                	addiw	a5,a5,1
    80004152:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004156:	8526                	mv	a0,s1
    80004158:	d56fe0ef          	jal	800026ae <iupdate>
  iunlock(ip);
    8000415c:	8526                	mv	a0,s1
    8000415e:	eb2fe0ef          	jal	80002810 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004162:	fd040593          	addi	a1,s0,-48
    80004166:	f5040513          	addi	a0,s0,-176
    8000416a:	cedfe0ef          	jal	80002e56 <nameiparent>
    8000416e:	892a                	mv	s2,a0
    80004170:	cd21                	beqz	a0,800041c8 <sys_link+0xce>
  ilock(dp);
    80004172:	df0fe0ef          	jal	80002762 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004176:	00092703          	lw	a4,0(s2)
    8000417a:	409c                	lw	a5,0(s1)
    8000417c:	04f71363          	bne	a4,a5,800041c2 <sys_link+0xc8>
    80004180:	40d0                	lw	a2,4(s1)
    80004182:	fd040593          	addi	a1,s0,-48
    80004186:	854a                	mv	a0,s2
    80004188:	c1bfe0ef          	jal	80002da2 <dirlink>
    8000418c:	02054b63          	bltz	a0,800041c2 <sys_link+0xc8>
  iunlockput(dp);
    80004190:	854a                	mv	a0,s2
    80004192:	fdafe0ef          	jal	8000296c <iunlockput>
  iput(ip);
    80004196:	8526                	mv	a0,s1
    80004198:	f4cfe0ef          	jal	800028e4 <iput>
  end_op();
    8000419c:	ec7fe0ef          	jal	80003062 <end_op>
  return 0;
    800041a0:	4781                	li	a5,0
    800041a2:	64f2                	ld	s1,280(sp)
    800041a4:	6952                	ld	s2,272(sp)
    800041a6:	a0a1                	j	800041ee <sys_link+0xf4>
    end_op();
    800041a8:	ebbfe0ef          	jal	80003062 <end_op>
    return -1;
    800041ac:	57fd                	li	a5,-1
    800041ae:	64f2                	ld	s1,280(sp)
    800041b0:	a83d                	j	800041ee <sys_link+0xf4>
    iunlockput(ip);
    800041b2:	8526                	mv	a0,s1
    800041b4:	fb8fe0ef          	jal	8000296c <iunlockput>
    end_op();
    800041b8:	eabfe0ef          	jal	80003062 <end_op>
    return -1;
    800041bc:	57fd                	li	a5,-1
    800041be:	64f2                	ld	s1,280(sp)
    800041c0:	a03d                	j	800041ee <sys_link+0xf4>
    iunlockput(dp);
    800041c2:	854a                	mv	a0,s2
    800041c4:	fa8fe0ef          	jal	8000296c <iunlockput>
  ilock(ip);
    800041c8:	8526                	mv	a0,s1
    800041ca:	d98fe0ef          	jal	80002762 <ilock>
  ip->nlink--;
    800041ce:	04a4d783          	lhu	a5,74(s1)
    800041d2:	37fd                	addiw	a5,a5,-1
    800041d4:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800041d8:	8526                	mv	a0,s1
    800041da:	cd4fe0ef          	jal	800026ae <iupdate>
  iunlockput(ip);
    800041de:	8526                	mv	a0,s1
    800041e0:	f8cfe0ef          	jal	8000296c <iunlockput>
  end_op();
    800041e4:	e7ffe0ef          	jal	80003062 <end_op>
  return -1;
    800041e8:	57fd                	li	a5,-1
    800041ea:	64f2                	ld	s1,280(sp)
    800041ec:	6952                	ld	s2,272(sp)
}
    800041ee:	853e                	mv	a0,a5
    800041f0:	70b2                	ld	ra,296(sp)
    800041f2:	7412                	ld	s0,288(sp)
    800041f4:	6155                	addi	sp,sp,304
    800041f6:	8082                	ret

00000000800041f8 <sys_unlink>:
{
    800041f8:	7151                	addi	sp,sp,-240
    800041fa:	f586                	sd	ra,232(sp)
    800041fc:	f1a2                	sd	s0,224(sp)
    800041fe:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004200:	08000613          	li	a2,128
    80004204:	f3040593          	addi	a1,s0,-208
    80004208:	4501                	li	a0,0
    8000420a:	ac7fd0ef          	jal	80001cd0 <argstr>
    8000420e:	16054063          	bltz	a0,8000436e <sys_unlink+0x176>
    80004212:	eda6                	sd	s1,216(sp)
  begin_op();
    80004214:	de5fe0ef          	jal	80002ff8 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004218:	fb040593          	addi	a1,s0,-80
    8000421c:	f3040513          	addi	a0,s0,-208
    80004220:	c37fe0ef          	jal	80002e56 <nameiparent>
    80004224:	84aa                	mv	s1,a0
    80004226:	c945                	beqz	a0,800042d6 <sys_unlink+0xde>
  ilock(dp);
    80004228:	d3afe0ef          	jal	80002762 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    8000422c:	00003597          	auipc	a1,0x3
    80004230:	45458593          	addi	a1,a1,1108 # 80007680 <etext+0x680>
    80004234:	fb040513          	addi	a0,s0,-80
    80004238:	989fe0ef          	jal	80002bc0 <namecmp>
    8000423c:	10050e63          	beqz	a0,80004358 <sys_unlink+0x160>
    80004240:	00003597          	auipc	a1,0x3
    80004244:	44858593          	addi	a1,a1,1096 # 80007688 <etext+0x688>
    80004248:	fb040513          	addi	a0,s0,-80
    8000424c:	975fe0ef          	jal	80002bc0 <namecmp>
    80004250:	10050463          	beqz	a0,80004358 <sys_unlink+0x160>
    80004254:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004256:	f2c40613          	addi	a2,s0,-212
    8000425a:	fb040593          	addi	a1,s0,-80
    8000425e:	8526                	mv	a0,s1
    80004260:	977fe0ef          	jal	80002bd6 <dirlookup>
    80004264:	892a                	mv	s2,a0
    80004266:	0e050863          	beqz	a0,80004356 <sys_unlink+0x15e>
  ilock(ip);
    8000426a:	cf8fe0ef          	jal	80002762 <ilock>
  if(ip->nlink < 1)
    8000426e:	04a91783          	lh	a5,74(s2)
    80004272:	06f05763          	blez	a5,800042e0 <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004276:	04491703          	lh	a4,68(s2)
    8000427a:	4785                	li	a5,1
    8000427c:	06f70963          	beq	a4,a5,800042ee <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    80004280:	4641                	li	a2,16
    80004282:	4581                	li	a1,0
    80004284:	fc040513          	addi	a0,s0,-64
    80004288:	eeffb0ef          	jal	80000176 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000428c:	4741                	li	a4,16
    8000428e:	f2c42683          	lw	a3,-212(s0)
    80004292:	fc040613          	addi	a2,s0,-64
    80004296:	4581                	li	a1,0
    80004298:	8526                	mv	a0,s1
    8000429a:	819fe0ef          	jal	80002ab2 <writei>
    8000429e:	47c1                	li	a5,16
    800042a0:	08f51b63          	bne	a0,a5,80004336 <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    800042a4:	04491703          	lh	a4,68(s2)
    800042a8:	4785                	li	a5,1
    800042aa:	08f70d63          	beq	a4,a5,80004344 <sys_unlink+0x14c>
  iunlockput(dp);
    800042ae:	8526                	mv	a0,s1
    800042b0:	ebcfe0ef          	jal	8000296c <iunlockput>
  ip->nlink--;
    800042b4:	04a95783          	lhu	a5,74(s2)
    800042b8:	37fd                	addiw	a5,a5,-1
    800042ba:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800042be:	854a                	mv	a0,s2
    800042c0:	beefe0ef          	jal	800026ae <iupdate>
  iunlockput(ip);
    800042c4:	854a                	mv	a0,s2
    800042c6:	ea6fe0ef          	jal	8000296c <iunlockput>
  end_op();
    800042ca:	d99fe0ef          	jal	80003062 <end_op>
  return 0;
    800042ce:	4501                	li	a0,0
    800042d0:	64ee                	ld	s1,216(sp)
    800042d2:	694e                	ld	s2,208(sp)
    800042d4:	a849                	j	80004366 <sys_unlink+0x16e>
    end_op();
    800042d6:	d8dfe0ef          	jal	80003062 <end_op>
    return -1;
    800042da:	557d                	li	a0,-1
    800042dc:	64ee                	ld	s1,216(sp)
    800042de:	a061                	j	80004366 <sys_unlink+0x16e>
    800042e0:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    800042e2:	00003517          	auipc	a0,0x3
    800042e6:	3ae50513          	addi	a0,a0,942 # 80007690 <etext+0x690>
    800042ea:	278010ef          	jal	80005562 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800042ee:	04c92703          	lw	a4,76(s2)
    800042f2:	02000793          	li	a5,32
    800042f6:	f8e7f5e3          	bgeu	a5,a4,80004280 <sys_unlink+0x88>
    800042fa:	e5ce                	sd	s3,200(sp)
    800042fc:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004300:	4741                	li	a4,16
    80004302:	86ce                	mv	a3,s3
    80004304:	f1840613          	addi	a2,s0,-232
    80004308:	4581                	li	a1,0
    8000430a:	854a                	mv	a0,s2
    8000430c:	eaafe0ef          	jal	800029b6 <readi>
    80004310:	47c1                	li	a5,16
    80004312:	00f51c63          	bne	a0,a5,8000432a <sys_unlink+0x132>
    if(de.inum != 0)
    80004316:	f1845783          	lhu	a5,-232(s0)
    8000431a:	efa1                	bnez	a5,80004372 <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000431c:	29c1                	addiw	s3,s3,16
    8000431e:	04c92783          	lw	a5,76(s2)
    80004322:	fcf9efe3          	bltu	s3,a5,80004300 <sys_unlink+0x108>
    80004326:	69ae                	ld	s3,200(sp)
    80004328:	bfa1                	j	80004280 <sys_unlink+0x88>
      panic("isdirempty: readi");
    8000432a:	00003517          	auipc	a0,0x3
    8000432e:	37e50513          	addi	a0,a0,894 # 800076a8 <etext+0x6a8>
    80004332:	230010ef          	jal	80005562 <panic>
    80004336:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004338:	00003517          	auipc	a0,0x3
    8000433c:	38850513          	addi	a0,a0,904 # 800076c0 <etext+0x6c0>
    80004340:	222010ef          	jal	80005562 <panic>
    dp->nlink--;
    80004344:	04a4d783          	lhu	a5,74(s1)
    80004348:	37fd                	addiw	a5,a5,-1
    8000434a:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000434e:	8526                	mv	a0,s1
    80004350:	b5efe0ef          	jal	800026ae <iupdate>
    80004354:	bfa9                	j	800042ae <sys_unlink+0xb6>
    80004356:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004358:	8526                	mv	a0,s1
    8000435a:	e12fe0ef          	jal	8000296c <iunlockput>
  end_op();
    8000435e:	d05fe0ef          	jal	80003062 <end_op>
  return -1;
    80004362:	557d                	li	a0,-1
    80004364:	64ee                	ld	s1,216(sp)
}
    80004366:	70ae                	ld	ra,232(sp)
    80004368:	740e                	ld	s0,224(sp)
    8000436a:	616d                	addi	sp,sp,240
    8000436c:	8082                	ret
    return -1;
    8000436e:	557d                	li	a0,-1
    80004370:	bfdd                	j	80004366 <sys_unlink+0x16e>
    iunlockput(ip);
    80004372:	854a                	mv	a0,s2
    80004374:	df8fe0ef          	jal	8000296c <iunlockput>
    goto bad;
    80004378:	694e                	ld	s2,208(sp)
    8000437a:	69ae                	ld	s3,200(sp)
    8000437c:	bff1                	j	80004358 <sys_unlink+0x160>

000000008000437e <sys_open>:

uint64
sys_open(void)
{
    8000437e:	7131                	addi	sp,sp,-192
    80004380:	fd06                	sd	ra,184(sp)
    80004382:	f922                	sd	s0,176(sp)
    80004384:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004386:	f4c40593          	addi	a1,s0,-180
    8000438a:	4505                	li	a0,1
    8000438c:	90dfd0ef          	jal	80001c98 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004390:	08000613          	li	a2,128
    80004394:	f5040593          	addi	a1,s0,-176
    80004398:	4501                	li	a0,0
    8000439a:	937fd0ef          	jal	80001cd0 <argstr>
    8000439e:	87aa                	mv	a5,a0
    return -1;
    800043a0:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    800043a2:	0a07c263          	bltz	a5,80004446 <sys_open+0xc8>
    800043a6:	f526                	sd	s1,168(sp)

  begin_op();
    800043a8:	c51fe0ef          	jal	80002ff8 <begin_op>

  if(omode & O_CREATE){
    800043ac:	f4c42783          	lw	a5,-180(s0)
    800043b0:	2007f793          	andi	a5,a5,512
    800043b4:	c3d5                	beqz	a5,80004458 <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    800043b6:	4681                	li	a3,0
    800043b8:	4601                	li	a2,0
    800043ba:	4589                	li	a1,2
    800043bc:	f5040513          	addi	a0,s0,-176
    800043c0:	aa9ff0ef          	jal	80003e68 <create>
    800043c4:	84aa                	mv	s1,a0
    if(ip == 0){
    800043c6:	c541                	beqz	a0,8000444e <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    800043c8:	04449703          	lh	a4,68(s1)
    800043cc:	478d                	li	a5,3
    800043ce:	00f71763          	bne	a4,a5,800043dc <sys_open+0x5e>
    800043d2:	0464d703          	lhu	a4,70(s1)
    800043d6:	47a5                	li	a5,9
    800043d8:	0ae7ed63          	bltu	a5,a4,80004492 <sys_open+0x114>
    800043dc:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    800043de:	f91fe0ef          	jal	8000336e <filealloc>
    800043e2:	892a                	mv	s2,a0
    800043e4:	c179                	beqz	a0,800044aa <sys_open+0x12c>
    800043e6:	ed4e                	sd	s3,152(sp)
    800043e8:	a43ff0ef          	jal	80003e2a <fdalloc>
    800043ec:	89aa                	mv	s3,a0
    800043ee:	0a054a63          	bltz	a0,800044a2 <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    800043f2:	04449703          	lh	a4,68(s1)
    800043f6:	478d                	li	a5,3
    800043f8:	0cf70263          	beq	a4,a5,800044bc <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    800043fc:	4789                	li	a5,2
    800043fe:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004402:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004406:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    8000440a:	f4c42783          	lw	a5,-180(s0)
    8000440e:	0017c713          	xori	a4,a5,1
    80004412:	8b05                	andi	a4,a4,1
    80004414:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004418:	0037f713          	andi	a4,a5,3
    8000441c:	00e03733          	snez	a4,a4
    80004420:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004424:	4007f793          	andi	a5,a5,1024
    80004428:	c791                	beqz	a5,80004434 <sys_open+0xb6>
    8000442a:	04449703          	lh	a4,68(s1)
    8000442e:	4789                	li	a5,2
    80004430:	08f70d63          	beq	a4,a5,800044ca <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    80004434:	8526                	mv	a0,s1
    80004436:	bdafe0ef          	jal	80002810 <iunlock>
  end_op();
    8000443a:	c29fe0ef          	jal	80003062 <end_op>

  return fd;
    8000443e:	854e                	mv	a0,s3
    80004440:	74aa                	ld	s1,168(sp)
    80004442:	790a                	ld	s2,160(sp)
    80004444:	69ea                	ld	s3,152(sp)
}
    80004446:	70ea                	ld	ra,184(sp)
    80004448:	744a                	ld	s0,176(sp)
    8000444a:	6129                	addi	sp,sp,192
    8000444c:	8082                	ret
      end_op();
    8000444e:	c15fe0ef          	jal	80003062 <end_op>
      return -1;
    80004452:	557d                	li	a0,-1
    80004454:	74aa                	ld	s1,168(sp)
    80004456:	bfc5                	j	80004446 <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    80004458:	f5040513          	addi	a0,s0,-176
    8000445c:	9e1fe0ef          	jal	80002e3c <namei>
    80004460:	84aa                	mv	s1,a0
    80004462:	c11d                	beqz	a0,80004488 <sys_open+0x10a>
    ilock(ip);
    80004464:	afefe0ef          	jal	80002762 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004468:	04449703          	lh	a4,68(s1)
    8000446c:	4785                	li	a5,1
    8000446e:	f4f71de3          	bne	a4,a5,800043c8 <sys_open+0x4a>
    80004472:	f4c42783          	lw	a5,-180(s0)
    80004476:	d3bd                	beqz	a5,800043dc <sys_open+0x5e>
      iunlockput(ip);
    80004478:	8526                	mv	a0,s1
    8000447a:	cf2fe0ef          	jal	8000296c <iunlockput>
      end_op();
    8000447e:	be5fe0ef          	jal	80003062 <end_op>
      return -1;
    80004482:	557d                	li	a0,-1
    80004484:	74aa                	ld	s1,168(sp)
    80004486:	b7c1                	j	80004446 <sys_open+0xc8>
      end_op();
    80004488:	bdbfe0ef          	jal	80003062 <end_op>
      return -1;
    8000448c:	557d                	li	a0,-1
    8000448e:	74aa                	ld	s1,168(sp)
    80004490:	bf5d                	j	80004446 <sys_open+0xc8>
    iunlockput(ip);
    80004492:	8526                	mv	a0,s1
    80004494:	cd8fe0ef          	jal	8000296c <iunlockput>
    end_op();
    80004498:	bcbfe0ef          	jal	80003062 <end_op>
    return -1;
    8000449c:	557d                	li	a0,-1
    8000449e:	74aa                	ld	s1,168(sp)
    800044a0:	b75d                	j	80004446 <sys_open+0xc8>
      fileclose(f);
    800044a2:	854a                	mv	a0,s2
    800044a4:	f6ffe0ef          	jal	80003412 <fileclose>
    800044a8:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    800044aa:	8526                	mv	a0,s1
    800044ac:	cc0fe0ef          	jal	8000296c <iunlockput>
    end_op();
    800044b0:	bb3fe0ef          	jal	80003062 <end_op>
    return -1;
    800044b4:	557d                	li	a0,-1
    800044b6:	74aa                	ld	s1,168(sp)
    800044b8:	790a                	ld	s2,160(sp)
    800044ba:	b771                	j	80004446 <sys_open+0xc8>
    f->type = FD_DEVICE;
    800044bc:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    800044c0:	04649783          	lh	a5,70(s1)
    800044c4:	02f91223          	sh	a5,36(s2)
    800044c8:	bf3d                	j	80004406 <sys_open+0x88>
    itrunc(ip);
    800044ca:	8526                	mv	a0,s1
    800044cc:	b84fe0ef          	jal	80002850 <itrunc>
    800044d0:	b795                	j	80004434 <sys_open+0xb6>

00000000800044d2 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    800044d2:	7175                	addi	sp,sp,-144
    800044d4:	e506                	sd	ra,136(sp)
    800044d6:	e122                	sd	s0,128(sp)
    800044d8:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    800044da:	b1ffe0ef          	jal	80002ff8 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    800044de:	08000613          	li	a2,128
    800044e2:	f7040593          	addi	a1,s0,-144
    800044e6:	4501                	li	a0,0
    800044e8:	fe8fd0ef          	jal	80001cd0 <argstr>
    800044ec:	02054363          	bltz	a0,80004512 <sys_mkdir+0x40>
    800044f0:	4681                	li	a3,0
    800044f2:	4601                	li	a2,0
    800044f4:	4585                	li	a1,1
    800044f6:	f7040513          	addi	a0,s0,-144
    800044fa:	96fff0ef          	jal	80003e68 <create>
    800044fe:	c911                	beqz	a0,80004512 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004500:	c6cfe0ef          	jal	8000296c <iunlockput>
  end_op();
    80004504:	b5ffe0ef          	jal	80003062 <end_op>
  return 0;
    80004508:	4501                	li	a0,0
}
    8000450a:	60aa                	ld	ra,136(sp)
    8000450c:	640a                	ld	s0,128(sp)
    8000450e:	6149                	addi	sp,sp,144
    80004510:	8082                	ret
    end_op();
    80004512:	b51fe0ef          	jal	80003062 <end_op>
    return -1;
    80004516:	557d                	li	a0,-1
    80004518:	bfcd                	j	8000450a <sys_mkdir+0x38>

000000008000451a <sys_mknod>:

uint64
sys_mknod(void)
{
    8000451a:	7135                	addi	sp,sp,-160
    8000451c:	ed06                	sd	ra,152(sp)
    8000451e:	e922                	sd	s0,144(sp)
    80004520:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004522:	ad7fe0ef          	jal	80002ff8 <begin_op>
  argint(1, &major);
    80004526:	f6c40593          	addi	a1,s0,-148
    8000452a:	4505                	li	a0,1
    8000452c:	f6cfd0ef          	jal	80001c98 <argint>
  argint(2, &minor);
    80004530:	f6840593          	addi	a1,s0,-152
    80004534:	4509                	li	a0,2
    80004536:	f62fd0ef          	jal	80001c98 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000453a:	08000613          	li	a2,128
    8000453e:	f7040593          	addi	a1,s0,-144
    80004542:	4501                	li	a0,0
    80004544:	f8cfd0ef          	jal	80001cd0 <argstr>
    80004548:	02054563          	bltz	a0,80004572 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    8000454c:	f6841683          	lh	a3,-152(s0)
    80004550:	f6c41603          	lh	a2,-148(s0)
    80004554:	458d                	li	a1,3
    80004556:	f7040513          	addi	a0,s0,-144
    8000455a:	90fff0ef          	jal	80003e68 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000455e:	c911                	beqz	a0,80004572 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004560:	c0cfe0ef          	jal	8000296c <iunlockput>
  end_op();
    80004564:	afffe0ef          	jal	80003062 <end_op>
  return 0;
    80004568:	4501                	li	a0,0
}
    8000456a:	60ea                	ld	ra,152(sp)
    8000456c:	644a                	ld	s0,144(sp)
    8000456e:	610d                	addi	sp,sp,160
    80004570:	8082                	ret
    end_op();
    80004572:	af1fe0ef          	jal	80003062 <end_op>
    return -1;
    80004576:	557d                	li	a0,-1
    80004578:	bfcd                	j	8000456a <sys_mknod+0x50>

000000008000457a <sys_chdir>:

uint64
sys_chdir(void)
{
    8000457a:	7135                	addi	sp,sp,-160
    8000457c:	ed06                	sd	ra,152(sp)
    8000457e:	e922                	sd	s0,144(sp)
    80004580:	e14a                	sd	s2,128(sp)
    80004582:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004584:	815fc0ef          	jal	80000d98 <myproc>
    80004588:	892a                	mv	s2,a0
  
  begin_op();
    8000458a:	a6ffe0ef          	jal	80002ff8 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    8000458e:	08000613          	li	a2,128
    80004592:	f6040593          	addi	a1,s0,-160
    80004596:	4501                	li	a0,0
    80004598:	f38fd0ef          	jal	80001cd0 <argstr>
    8000459c:	04054363          	bltz	a0,800045e2 <sys_chdir+0x68>
    800045a0:	e526                	sd	s1,136(sp)
    800045a2:	f6040513          	addi	a0,s0,-160
    800045a6:	897fe0ef          	jal	80002e3c <namei>
    800045aa:	84aa                	mv	s1,a0
    800045ac:	c915                	beqz	a0,800045e0 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    800045ae:	9b4fe0ef          	jal	80002762 <ilock>
  if(ip->type != T_DIR){
    800045b2:	04449703          	lh	a4,68(s1)
    800045b6:	4785                	li	a5,1
    800045b8:	02f71963          	bne	a4,a5,800045ea <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800045bc:	8526                	mv	a0,s1
    800045be:	a52fe0ef          	jal	80002810 <iunlock>
  iput(p->cwd);
    800045c2:	15093503          	ld	a0,336(s2)
    800045c6:	b1efe0ef          	jal	800028e4 <iput>
  end_op();
    800045ca:	a99fe0ef          	jal	80003062 <end_op>
  p->cwd = ip;
    800045ce:	14993823          	sd	s1,336(s2)
  return 0;
    800045d2:	4501                	li	a0,0
    800045d4:	64aa                	ld	s1,136(sp)
}
    800045d6:	60ea                	ld	ra,152(sp)
    800045d8:	644a                	ld	s0,144(sp)
    800045da:	690a                	ld	s2,128(sp)
    800045dc:	610d                	addi	sp,sp,160
    800045de:	8082                	ret
    800045e0:	64aa                	ld	s1,136(sp)
    end_op();
    800045e2:	a81fe0ef          	jal	80003062 <end_op>
    return -1;
    800045e6:	557d                	li	a0,-1
    800045e8:	b7fd                	j	800045d6 <sys_chdir+0x5c>
    iunlockput(ip);
    800045ea:	8526                	mv	a0,s1
    800045ec:	b80fe0ef          	jal	8000296c <iunlockput>
    end_op();
    800045f0:	a73fe0ef          	jal	80003062 <end_op>
    return -1;
    800045f4:	557d                	li	a0,-1
    800045f6:	64aa                	ld	s1,136(sp)
    800045f8:	bff9                	j	800045d6 <sys_chdir+0x5c>

00000000800045fa <sys_exec>:

uint64
sys_exec(void)
{
    800045fa:	7121                	addi	sp,sp,-448
    800045fc:	ff06                	sd	ra,440(sp)
    800045fe:	fb22                	sd	s0,432(sp)
    80004600:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004602:	e4840593          	addi	a1,s0,-440
    80004606:	4505                	li	a0,1
    80004608:	eacfd0ef          	jal	80001cb4 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    8000460c:	08000613          	li	a2,128
    80004610:	f5040593          	addi	a1,s0,-176
    80004614:	4501                	li	a0,0
    80004616:	ebafd0ef          	jal	80001cd0 <argstr>
    8000461a:	87aa                	mv	a5,a0
    return -1;
    8000461c:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    8000461e:	0c07c463          	bltz	a5,800046e6 <sys_exec+0xec>
    80004622:	f726                	sd	s1,424(sp)
    80004624:	f34a                	sd	s2,416(sp)
    80004626:	ef4e                	sd	s3,408(sp)
    80004628:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    8000462a:	10000613          	li	a2,256
    8000462e:	4581                	li	a1,0
    80004630:	e5040513          	addi	a0,s0,-432
    80004634:	b43fb0ef          	jal	80000176 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004638:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    8000463c:	89a6                	mv	s3,s1
    8000463e:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004640:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004644:	00391513          	slli	a0,s2,0x3
    80004648:	e4040593          	addi	a1,s0,-448
    8000464c:	e4843783          	ld	a5,-440(s0)
    80004650:	953e                	add	a0,a0,a5
    80004652:	dbcfd0ef          	jal	80001c0e <fetchaddr>
    80004656:	02054663          	bltz	a0,80004682 <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    8000465a:	e4043783          	ld	a5,-448(s0)
    8000465e:	c3a9                	beqz	a5,800046a0 <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004660:	a97fb0ef          	jal	800000f6 <kalloc>
    80004664:	85aa                	mv	a1,a0
    80004666:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000466a:	cd01                	beqz	a0,80004682 <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000466c:	6605                	lui	a2,0x1
    8000466e:	e4043503          	ld	a0,-448(s0)
    80004672:	de6fd0ef          	jal	80001c58 <fetchstr>
    80004676:	00054663          	bltz	a0,80004682 <sys_exec+0x88>
    if(i >= NELEM(argv)){
    8000467a:	0905                	addi	s2,s2,1
    8000467c:	09a1                	addi	s3,s3,8
    8000467e:	fd4913e3          	bne	s2,s4,80004644 <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004682:	f5040913          	addi	s2,s0,-176
    80004686:	6088                	ld	a0,0(s1)
    80004688:	c931                	beqz	a0,800046dc <sys_exec+0xe2>
    kfree(argv[i]);
    8000468a:	993fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000468e:	04a1                	addi	s1,s1,8
    80004690:	ff249be3          	bne	s1,s2,80004686 <sys_exec+0x8c>
  return -1;
    80004694:	557d                	li	a0,-1
    80004696:	74ba                	ld	s1,424(sp)
    80004698:	791a                	ld	s2,416(sp)
    8000469a:	69fa                	ld	s3,408(sp)
    8000469c:	6a5a                	ld	s4,400(sp)
    8000469e:	a0a1                	j	800046e6 <sys_exec+0xec>
      argv[i] = 0;
    800046a0:	0009079b          	sext.w	a5,s2
    800046a4:	078e                	slli	a5,a5,0x3
    800046a6:	fd078793          	addi	a5,a5,-48
    800046aa:	97a2                	add	a5,a5,s0
    800046ac:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    800046b0:	e5040593          	addi	a1,s0,-432
    800046b4:	f5040513          	addi	a0,s0,-176
    800046b8:	ba8ff0ef          	jal	80003a60 <exec>
    800046bc:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800046be:	f5040993          	addi	s3,s0,-176
    800046c2:	6088                	ld	a0,0(s1)
    800046c4:	c511                	beqz	a0,800046d0 <sys_exec+0xd6>
    kfree(argv[i]);
    800046c6:	957fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800046ca:	04a1                	addi	s1,s1,8
    800046cc:	ff349be3          	bne	s1,s3,800046c2 <sys_exec+0xc8>
  return ret;
    800046d0:	854a                	mv	a0,s2
    800046d2:	74ba                	ld	s1,424(sp)
    800046d4:	791a                	ld	s2,416(sp)
    800046d6:	69fa                	ld	s3,408(sp)
    800046d8:	6a5a                	ld	s4,400(sp)
    800046da:	a031                	j	800046e6 <sys_exec+0xec>
  return -1;
    800046dc:	557d                	li	a0,-1
    800046de:	74ba                	ld	s1,424(sp)
    800046e0:	791a                	ld	s2,416(sp)
    800046e2:	69fa                	ld	s3,408(sp)
    800046e4:	6a5a                	ld	s4,400(sp)
}
    800046e6:	70fa                	ld	ra,440(sp)
    800046e8:	745a                	ld	s0,432(sp)
    800046ea:	6139                	addi	sp,sp,448
    800046ec:	8082                	ret

00000000800046ee <sys_pipe>:

uint64
sys_pipe(void)
{
    800046ee:	7139                	addi	sp,sp,-64
    800046f0:	fc06                	sd	ra,56(sp)
    800046f2:	f822                	sd	s0,48(sp)
    800046f4:	f426                	sd	s1,40(sp)
    800046f6:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800046f8:	ea0fc0ef          	jal	80000d98 <myproc>
    800046fc:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800046fe:	fd840593          	addi	a1,s0,-40
    80004702:	4501                	li	a0,0
    80004704:	db0fd0ef          	jal	80001cb4 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004708:	fc840593          	addi	a1,s0,-56
    8000470c:	fd040513          	addi	a0,s0,-48
    80004710:	85cff0ef          	jal	8000376c <pipealloc>
    return -1;
    80004714:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004716:	0a054463          	bltz	a0,800047be <sys_pipe+0xd0>
  fd0 = -1;
    8000471a:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000471e:	fd043503          	ld	a0,-48(s0)
    80004722:	f08ff0ef          	jal	80003e2a <fdalloc>
    80004726:	fca42223          	sw	a0,-60(s0)
    8000472a:	08054163          	bltz	a0,800047ac <sys_pipe+0xbe>
    8000472e:	fc843503          	ld	a0,-56(s0)
    80004732:	ef8ff0ef          	jal	80003e2a <fdalloc>
    80004736:	fca42023          	sw	a0,-64(s0)
    8000473a:	06054063          	bltz	a0,8000479a <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000473e:	4691                	li	a3,4
    80004740:	fc440613          	addi	a2,s0,-60
    80004744:	fd843583          	ld	a1,-40(s0)
    80004748:	68a8                	ld	a0,80(s1)
    8000474a:	abefc0ef          	jal	80000a08 <copyout>
    8000474e:	00054e63          	bltz	a0,8000476a <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004752:	4691                	li	a3,4
    80004754:	fc040613          	addi	a2,s0,-64
    80004758:	fd843583          	ld	a1,-40(s0)
    8000475c:	0591                	addi	a1,a1,4
    8000475e:	68a8                	ld	a0,80(s1)
    80004760:	aa8fc0ef          	jal	80000a08 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004764:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004766:	04055c63          	bgez	a0,800047be <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    8000476a:	fc442783          	lw	a5,-60(s0)
    8000476e:	07e9                	addi	a5,a5,26
    80004770:	078e                	slli	a5,a5,0x3
    80004772:	97a6                	add	a5,a5,s1
    80004774:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004778:	fc042783          	lw	a5,-64(s0)
    8000477c:	07e9                	addi	a5,a5,26
    8000477e:	078e                	slli	a5,a5,0x3
    80004780:	94be                	add	s1,s1,a5
    80004782:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80004786:	fd043503          	ld	a0,-48(s0)
    8000478a:	c89fe0ef          	jal	80003412 <fileclose>
    fileclose(wf);
    8000478e:	fc843503          	ld	a0,-56(s0)
    80004792:	c81fe0ef          	jal	80003412 <fileclose>
    return -1;
    80004796:	57fd                	li	a5,-1
    80004798:	a01d                	j	800047be <sys_pipe+0xd0>
    if(fd0 >= 0)
    8000479a:	fc442783          	lw	a5,-60(s0)
    8000479e:	0007c763          	bltz	a5,800047ac <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    800047a2:	07e9                	addi	a5,a5,26
    800047a4:	078e                	slli	a5,a5,0x3
    800047a6:	97a6                	add	a5,a5,s1
    800047a8:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800047ac:	fd043503          	ld	a0,-48(s0)
    800047b0:	c63fe0ef          	jal	80003412 <fileclose>
    fileclose(wf);
    800047b4:	fc843503          	ld	a0,-56(s0)
    800047b8:	c5bfe0ef          	jal	80003412 <fileclose>
    return -1;
    800047bc:	57fd                	li	a5,-1
}
    800047be:	853e                	mv	a0,a5
    800047c0:	70e2                	ld	ra,56(sp)
    800047c2:	7442                	ld	s0,48(sp)
    800047c4:	74a2                	ld	s1,40(sp)
    800047c6:	6121                	addi	sp,sp,64
    800047c8:	8082                	ret
    800047ca:	0000                	unimp
    800047cc:	0000                	unimp
	...

00000000800047d0 <kernelvec>:
    800047d0:	7111                	addi	sp,sp,-256
    800047d2:	e006                	sd	ra,0(sp)
    800047d4:	e40a                	sd	sp,8(sp)
    800047d6:	e80e                	sd	gp,16(sp)
    800047d8:	ec12                	sd	tp,24(sp)
    800047da:	f016                	sd	t0,32(sp)
    800047dc:	f41a                	sd	t1,40(sp)
    800047de:	f81e                	sd	t2,48(sp)
    800047e0:	e4aa                	sd	a0,72(sp)
    800047e2:	e8ae                	sd	a1,80(sp)
    800047e4:	ecb2                	sd	a2,88(sp)
    800047e6:	f0b6                	sd	a3,96(sp)
    800047e8:	f4ba                	sd	a4,104(sp)
    800047ea:	f8be                	sd	a5,112(sp)
    800047ec:	fcc2                	sd	a6,120(sp)
    800047ee:	e146                	sd	a7,128(sp)
    800047f0:	edf2                	sd	t3,216(sp)
    800047f2:	f1f6                	sd	t4,224(sp)
    800047f4:	f5fa                	sd	t5,232(sp)
    800047f6:	f9fe                	sd	t6,240(sp)
    800047f8:	b26fd0ef          	jal	80001b1e <kerneltrap>
    800047fc:	6082                	ld	ra,0(sp)
    800047fe:	6122                	ld	sp,8(sp)
    80004800:	61c2                	ld	gp,16(sp)
    80004802:	7282                	ld	t0,32(sp)
    80004804:	7322                	ld	t1,40(sp)
    80004806:	73c2                	ld	t2,48(sp)
    80004808:	6526                	ld	a0,72(sp)
    8000480a:	65c6                	ld	a1,80(sp)
    8000480c:	6666                	ld	a2,88(sp)
    8000480e:	7686                	ld	a3,96(sp)
    80004810:	7726                	ld	a4,104(sp)
    80004812:	77c6                	ld	a5,112(sp)
    80004814:	7866                	ld	a6,120(sp)
    80004816:	688a                	ld	a7,128(sp)
    80004818:	6e6e                	ld	t3,216(sp)
    8000481a:	7e8e                	ld	t4,224(sp)
    8000481c:	7f2e                	ld	t5,232(sp)
    8000481e:	7fce                	ld	t6,240(sp)
    80004820:	6111                	addi	sp,sp,256
    80004822:	10200073          	sret
	...

000000008000482e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000482e:	1141                	addi	sp,sp,-16
    80004830:	e422                	sd	s0,8(sp)
    80004832:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80004834:	0c0007b7          	lui	a5,0xc000
    80004838:	4705                	li	a4,1
    8000483a:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000483c:	0c0007b7          	lui	a5,0xc000
    80004840:	c3d8                	sw	a4,4(a5)
}
    80004842:	6422                	ld	s0,8(sp)
    80004844:	0141                	addi	sp,sp,16
    80004846:	8082                	ret

0000000080004848 <plicinithart>:

void
plicinithart(void)
{
    80004848:	1141                	addi	sp,sp,-16
    8000484a:	e406                	sd	ra,8(sp)
    8000484c:	e022                	sd	s0,0(sp)
    8000484e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004850:	d1cfc0ef          	jal	80000d6c <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80004854:	0085171b          	slliw	a4,a0,0x8
    80004858:	0c0027b7          	lui	a5,0xc002
    8000485c:	97ba                	add	a5,a5,a4
    8000485e:	40200713          	li	a4,1026
    80004862:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80004866:	00d5151b          	slliw	a0,a0,0xd
    8000486a:	0c2017b7          	lui	a5,0xc201
    8000486e:	97aa                	add	a5,a5,a0
    80004870:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80004874:	60a2                	ld	ra,8(sp)
    80004876:	6402                	ld	s0,0(sp)
    80004878:	0141                	addi	sp,sp,16
    8000487a:	8082                	ret

000000008000487c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000487c:	1141                	addi	sp,sp,-16
    8000487e:	e406                	sd	ra,8(sp)
    80004880:	e022                	sd	s0,0(sp)
    80004882:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004884:	ce8fc0ef          	jal	80000d6c <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80004888:	00d5151b          	slliw	a0,a0,0xd
    8000488c:	0c2017b7          	lui	a5,0xc201
    80004890:	97aa                	add	a5,a5,a0
  return irq;
}
    80004892:	43c8                	lw	a0,4(a5)
    80004894:	60a2                	ld	ra,8(sp)
    80004896:	6402                	ld	s0,0(sp)
    80004898:	0141                	addi	sp,sp,16
    8000489a:	8082                	ret

000000008000489c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000489c:	1101                	addi	sp,sp,-32
    8000489e:	ec06                	sd	ra,24(sp)
    800048a0:	e822                	sd	s0,16(sp)
    800048a2:	e426                	sd	s1,8(sp)
    800048a4:	1000                	addi	s0,sp,32
    800048a6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800048a8:	cc4fc0ef          	jal	80000d6c <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800048ac:	00d5151b          	slliw	a0,a0,0xd
    800048b0:	0c2017b7          	lui	a5,0xc201
    800048b4:	97aa                	add	a5,a5,a0
    800048b6:	c3c4                	sw	s1,4(a5)
}
    800048b8:	60e2                	ld	ra,24(sp)
    800048ba:	6442                	ld	s0,16(sp)
    800048bc:	64a2                	ld	s1,8(sp)
    800048be:	6105                	addi	sp,sp,32
    800048c0:	8082                	ret

00000000800048c2 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800048c2:	1141                	addi	sp,sp,-16
    800048c4:	e406                	sd	ra,8(sp)
    800048c6:	e022                	sd	s0,0(sp)
    800048c8:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800048ca:	479d                	li	a5,7
    800048cc:	04a7ca63          	blt	a5,a0,80004920 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    800048d0:	00017797          	auipc	a5,0x17
    800048d4:	ca078793          	addi	a5,a5,-864 # 8001b570 <disk>
    800048d8:	97aa                	add	a5,a5,a0
    800048da:	0187c783          	lbu	a5,24(a5)
    800048de:	e7b9                	bnez	a5,8000492c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800048e0:	00451693          	slli	a3,a0,0x4
    800048e4:	00017797          	auipc	a5,0x17
    800048e8:	c8c78793          	addi	a5,a5,-884 # 8001b570 <disk>
    800048ec:	6398                	ld	a4,0(a5)
    800048ee:	9736                	add	a4,a4,a3
    800048f0:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    800048f4:	6398                	ld	a4,0(a5)
    800048f6:	9736                	add	a4,a4,a3
    800048f8:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800048fc:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80004900:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80004904:	97aa                	add	a5,a5,a0
    80004906:	4705                	li	a4,1
    80004908:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    8000490c:	00017517          	auipc	a0,0x17
    80004910:	c7c50513          	addi	a0,a0,-900 # 8001b588 <disk+0x18>
    80004914:	a9ffc0ef          	jal	800013b2 <wakeup>
}
    80004918:	60a2                	ld	ra,8(sp)
    8000491a:	6402                	ld	s0,0(sp)
    8000491c:	0141                	addi	sp,sp,16
    8000491e:	8082                	ret
    panic("free_desc 1");
    80004920:	00003517          	auipc	a0,0x3
    80004924:	db050513          	addi	a0,a0,-592 # 800076d0 <etext+0x6d0>
    80004928:	43b000ef          	jal	80005562 <panic>
    panic("free_desc 2");
    8000492c:	00003517          	auipc	a0,0x3
    80004930:	db450513          	addi	a0,a0,-588 # 800076e0 <etext+0x6e0>
    80004934:	42f000ef          	jal	80005562 <panic>

0000000080004938 <virtio_disk_init>:
{
    80004938:	1101                	addi	sp,sp,-32
    8000493a:	ec06                	sd	ra,24(sp)
    8000493c:	e822                	sd	s0,16(sp)
    8000493e:	e426                	sd	s1,8(sp)
    80004940:	e04a                	sd	s2,0(sp)
    80004942:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80004944:	00003597          	auipc	a1,0x3
    80004948:	dac58593          	addi	a1,a1,-596 # 800076f0 <etext+0x6f0>
    8000494c:	00017517          	auipc	a0,0x17
    80004950:	d4c50513          	addi	a0,a0,-692 # 8001b698 <disk+0x128>
    80004954:	6bd000ef          	jal	80005810 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004958:	100017b7          	lui	a5,0x10001
    8000495c:	4398                	lw	a4,0(a5)
    8000495e:	2701                	sext.w	a4,a4
    80004960:	747277b7          	lui	a5,0x74727
    80004964:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80004968:	18f71063          	bne	a4,a5,80004ae8 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000496c:	100017b7          	lui	a5,0x10001
    80004970:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    80004972:	439c                	lw	a5,0(a5)
    80004974:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004976:	4709                	li	a4,2
    80004978:	16e79863          	bne	a5,a4,80004ae8 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000497c:	100017b7          	lui	a5,0x10001
    80004980:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    80004982:	439c                	lw	a5,0(a5)
    80004984:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004986:	16e79163          	bne	a5,a4,80004ae8 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000498a:	100017b7          	lui	a5,0x10001
    8000498e:	47d8                	lw	a4,12(a5)
    80004990:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004992:	554d47b7          	lui	a5,0x554d4
    80004996:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000499a:	14f71763          	bne	a4,a5,80004ae8 <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000499e:	100017b7          	lui	a5,0x10001
    800049a2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800049a6:	4705                	li	a4,1
    800049a8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800049aa:	470d                	li	a4,3
    800049ac:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800049ae:	10001737          	lui	a4,0x10001
    800049b2:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800049b4:	c7ffe737          	lui	a4,0xc7ffe
    800049b8:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdafaf>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800049bc:	8ef9                	and	a3,a3,a4
    800049be:	10001737          	lui	a4,0x10001
    800049c2:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    800049c4:	472d                	li	a4,11
    800049c6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800049c8:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    800049cc:	439c                	lw	a5,0(a5)
    800049ce:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800049d2:	8ba1                	andi	a5,a5,8
    800049d4:	12078063          	beqz	a5,80004af4 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800049d8:	100017b7          	lui	a5,0x10001
    800049dc:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800049e0:	100017b7          	lui	a5,0x10001
    800049e4:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    800049e8:	439c                	lw	a5,0(a5)
    800049ea:	2781                	sext.w	a5,a5
    800049ec:	10079a63          	bnez	a5,80004b00 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800049f0:	100017b7          	lui	a5,0x10001
    800049f4:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    800049f8:	439c                	lw	a5,0(a5)
    800049fa:	2781                	sext.w	a5,a5
  if(max == 0)
    800049fc:	10078863          	beqz	a5,80004b0c <virtio_disk_init+0x1d4>
  if(max < NUM)
    80004a00:	471d                	li	a4,7
    80004a02:	10f77b63          	bgeu	a4,a5,80004b18 <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    80004a06:	ef0fb0ef          	jal	800000f6 <kalloc>
    80004a0a:	00017497          	auipc	s1,0x17
    80004a0e:	b6648493          	addi	s1,s1,-1178 # 8001b570 <disk>
    80004a12:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80004a14:	ee2fb0ef          	jal	800000f6 <kalloc>
    80004a18:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80004a1a:	edcfb0ef          	jal	800000f6 <kalloc>
    80004a1e:	87aa                	mv	a5,a0
    80004a20:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80004a22:	6088                	ld	a0,0(s1)
    80004a24:	10050063          	beqz	a0,80004b24 <virtio_disk_init+0x1ec>
    80004a28:	00017717          	auipc	a4,0x17
    80004a2c:	b5073703          	ld	a4,-1200(a4) # 8001b578 <disk+0x8>
    80004a30:	0e070a63          	beqz	a4,80004b24 <virtio_disk_init+0x1ec>
    80004a34:	0e078863          	beqz	a5,80004b24 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80004a38:	6605                	lui	a2,0x1
    80004a3a:	4581                	li	a1,0
    80004a3c:	f3afb0ef          	jal	80000176 <memset>
  memset(disk.avail, 0, PGSIZE);
    80004a40:	00017497          	auipc	s1,0x17
    80004a44:	b3048493          	addi	s1,s1,-1232 # 8001b570 <disk>
    80004a48:	6605                	lui	a2,0x1
    80004a4a:	4581                	li	a1,0
    80004a4c:	6488                	ld	a0,8(s1)
    80004a4e:	f28fb0ef          	jal	80000176 <memset>
  memset(disk.used, 0, PGSIZE);
    80004a52:	6605                	lui	a2,0x1
    80004a54:	4581                	li	a1,0
    80004a56:	6888                	ld	a0,16(s1)
    80004a58:	f1efb0ef          	jal	80000176 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80004a5c:	100017b7          	lui	a5,0x10001
    80004a60:	4721                	li	a4,8
    80004a62:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80004a64:	4098                	lw	a4,0(s1)
    80004a66:	100017b7          	lui	a5,0x10001
    80004a6a:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80004a6e:	40d8                	lw	a4,4(s1)
    80004a70:	100017b7          	lui	a5,0x10001
    80004a74:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80004a78:	649c                	ld	a5,8(s1)
    80004a7a:	0007869b          	sext.w	a3,a5
    80004a7e:	10001737          	lui	a4,0x10001
    80004a82:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80004a86:	9781                	srai	a5,a5,0x20
    80004a88:	10001737          	lui	a4,0x10001
    80004a8c:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80004a90:	689c                	ld	a5,16(s1)
    80004a92:	0007869b          	sext.w	a3,a5
    80004a96:	10001737          	lui	a4,0x10001
    80004a9a:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80004a9e:	9781                	srai	a5,a5,0x20
    80004aa0:	10001737          	lui	a4,0x10001
    80004aa4:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80004aa8:	10001737          	lui	a4,0x10001
    80004aac:	4785                	li	a5,1
    80004aae:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80004ab0:	00f48c23          	sb	a5,24(s1)
    80004ab4:	00f48ca3          	sb	a5,25(s1)
    80004ab8:	00f48d23          	sb	a5,26(s1)
    80004abc:	00f48da3          	sb	a5,27(s1)
    80004ac0:	00f48e23          	sb	a5,28(s1)
    80004ac4:	00f48ea3          	sb	a5,29(s1)
    80004ac8:	00f48f23          	sb	a5,30(s1)
    80004acc:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80004ad0:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80004ad4:	100017b7          	lui	a5,0x10001
    80004ad8:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    80004adc:	60e2                	ld	ra,24(sp)
    80004ade:	6442                	ld	s0,16(sp)
    80004ae0:	64a2                	ld	s1,8(sp)
    80004ae2:	6902                	ld	s2,0(sp)
    80004ae4:	6105                	addi	sp,sp,32
    80004ae6:	8082                	ret
    panic("could not find virtio disk");
    80004ae8:	00003517          	auipc	a0,0x3
    80004aec:	c1850513          	addi	a0,a0,-1000 # 80007700 <etext+0x700>
    80004af0:	273000ef          	jal	80005562 <panic>
    panic("virtio disk FEATURES_OK unset");
    80004af4:	00003517          	auipc	a0,0x3
    80004af8:	c2c50513          	addi	a0,a0,-980 # 80007720 <etext+0x720>
    80004afc:	267000ef          	jal	80005562 <panic>
    panic("virtio disk should not be ready");
    80004b00:	00003517          	auipc	a0,0x3
    80004b04:	c4050513          	addi	a0,a0,-960 # 80007740 <etext+0x740>
    80004b08:	25b000ef          	jal	80005562 <panic>
    panic("virtio disk has no queue 0");
    80004b0c:	00003517          	auipc	a0,0x3
    80004b10:	c5450513          	addi	a0,a0,-940 # 80007760 <etext+0x760>
    80004b14:	24f000ef          	jal	80005562 <panic>
    panic("virtio disk max queue too short");
    80004b18:	00003517          	auipc	a0,0x3
    80004b1c:	c6850513          	addi	a0,a0,-920 # 80007780 <etext+0x780>
    80004b20:	243000ef          	jal	80005562 <panic>
    panic("virtio disk kalloc");
    80004b24:	00003517          	auipc	a0,0x3
    80004b28:	c7c50513          	addi	a0,a0,-900 # 800077a0 <etext+0x7a0>
    80004b2c:	237000ef          	jal	80005562 <panic>

0000000080004b30 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80004b30:	7159                	addi	sp,sp,-112
    80004b32:	f486                	sd	ra,104(sp)
    80004b34:	f0a2                	sd	s0,96(sp)
    80004b36:	eca6                	sd	s1,88(sp)
    80004b38:	e8ca                	sd	s2,80(sp)
    80004b3a:	e4ce                	sd	s3,72(sp)
    80004b3c:	e0d2                	sd	s4,64(sp)
    80004b3e:	fc56                	sd	s5,56(sp)
    80004b40:	f85a                	sd	s6,48(sp)
    80004b42:	f45e                	sd	s7,40(sp)
    80004b44:	f062                	sd	s8,32(sp)
    80004b46:	ec66                	sd	s9,24(sp)
    80004b48:	1880                	addi	s0,sp,112
    80004b4a:	8a2a                	mv	s4,a0
    80004b4c:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80004b4e:	00c52c83          	lw	s9,12(a0)
    80004b52:	001c9c9b          	slliw	s9,s9,0x1
    80004b56:	1c82                	slli	s9,s9,0x20
    80004b58:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80004b5c:	00017517          	auipc	a0,0x17
    80004b60:	b3c50513          	addi	a0,a0,-1220 # 8001b698 <disk+0x128>
    80004b64:	52d000ef          	jal	80005890 <acquire>
  for(int i = 0; i < 3; i++){
    80004b68:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80004b6a:	44a1                	li	s1,8
      disk.free[i] = 0;
    80004b6c:	00017b17          	auipc	s6,0x17
    80004b70:	a04b0b13          	addi	s6,s6,-1532 # 8001b570 <disk>
  for(int i = 0; i < 3; i++){
    80004b74:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004b76:	00017c17          	auipc	s8,0x17
    80004b7a:	b22c0c13          	addi	s8,s8,-1246 # 8001b698 <disk+0x128>
    80004b7e:	a8b9                	j	80004bdc <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    80004b80:	00fb0733          	add	a4,s6,a5
    80004b84:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80004b88:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80004b8a:	0207c563          	bltz	a5,80004bb4 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    80004b8e:	2905                	addiw	s2,s2,1
    80004b90:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80004b92:	05590963          	beq	s2,s5,80004be4 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    80004b96:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80004b98:	00017717          	auipc	a4,0x17
    80004b9c:	9d870713          	addi	a4,a4,-1576 # 8001b570 <disk>
    80004ba0:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80004ba2:	01874683          	lbu	a3,24(a4)
    80004ba6:	fee9                	bnez	a3,80004b80 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    80004ba8:	2785                	addiw	a5,a5,1
    80004baa:	0705                	addi	a4,a4,1
    80004bac:	fe979be3          	bne	a5,s1,80004ba2 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80004bb0:	57fd                	li	a5,-1
    80004bb2:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80004bb4:	01205d63          	blez	s2,80004bce <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80004bb8:	f9042503          	lw	a0,-112(s0)
    80004bbc:	d07ff0ef          	jal	800048c2 <free_desc>
      for(int j = 0; j < i; j++)
    80004bc0:	4785                	li	a5,1
    80004bc2:	0127d663          	bge	a5,s2,80004bce <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80004bc6:	f9442503          	lw	a0,-108(s0)
    80004bca:	cf9ff0ef          	jal	800048c2 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004bce:	85e2                	mv	a1,s8
    80004bd0:	00017517          	auipc	a0,0x17
    80004bd4:	9b850513          	addi	a0,a0,-1608 # 8001b588 <disk+0x18>
    80004bd8:	f8efc0ef          	jal	80001366 <sleep>
  for(int i = 0; i < 3; i++){
    80004bdc:	f9040613          	addi	a2,s0,-112
    80004be0:	894e                	mv	s2,s3
    80004be2:	bf55                	j	80004b96 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004be4:	f9042503          	lw	a0,-112(s0)
    80004be8:	00451693          	slli	a3,a0,0x4

  if(write)
    80004bec:	00017797          	auipc	a5,0x17
    80004bf0:	98478793          	addi	a5,a5,-1660 # 8001b570 <disk>
    80004bf4:	00a50713          	addi	a4,a0,10
    80004bf8:	0712                	slli	a4,a4,0x4
    80004bfa:	973e                	add	a4,a4,a5
    80004bfc:	01703633          	snez	a2,s7
    80004c00:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80004c02:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80004c06:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80004c0a:	6398                	ld	a4,0(a5)
    80004c0c:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004c0e:	0a868613          	addi	a2,a3,168
    80004c12:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80004c14:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80004c16:	6390                	ld	a2,0(a5)
    80004c18:	00d605b3          	add	a1,a2,a3
    80004c1c:	4741                	li	a4,16
    80004c1e:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80004c20:	4805                	li	a6,1
    80004c22:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80004c26:	f9442703          	lw	a4,-108(s0)
    80004c2a:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80004c2e:	0712                	slli	a4,a4,0x4
    80004c30:	963a                	add	a2,a2,a4
    80004c32:	058a0593          	addi	a1,s4,88
    80004c36:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80004c38:	0007b883          	ld	a7,0(a5)
    80004c3c:	9746                	add	a4,a4,a7
    80004c3e:	40000613          	li	a2,1024
    80004c42:	c710                	sw	a2,8(a4)
  if(write)
    80004c44:	001bb613          	seqz	a2,s7
    80004c48:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80004c4c:	00166613          	ori	a2,a2,1
    80004c50:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80004c54:	f9842583          	lw	a1,-104(s0)
    80004c58:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80004c5c:	00250613          	addi	a2,a0,2
    80004c60:	0612                	slli	a2,a2,0x4
    80004c62:	963e                	add	a2,a2,a5
    80004c64:	577d                	li	a4,-1
    80004c66:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80004c6a:	0592                	slli	a1,a1,0x4
    80004c6c:	98ae                	add	a7,a7,a1
    80004c6e:	03068713          	addi	a4,a3,48
    80004c72:	973e                	add	a4,a4,a5
    80004c74:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80004c78:	6398                	ld	a4,0(a5)
    80004c7a:	972e                	add	a4,a4,a1
    80004c7c:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80004c80:	4689                	li	a3,2
    80004c82:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80004c86:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80004c8a:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80004c8e:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80004c92:	6794                	ld	a3,8(a5)
    80004c94:	0026d703          	lhu	a4,2(a3)
    80004c98:	8b1d                	andi	a4,a4,7
    80004c9a:	0706                	slli	a4,a4,0x1
    80004c9c:	96ba                	add	a3,a3,a4
    80004c9e:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80004ca2:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80004ca6:	6798                	ld	a4,8(a5)
    80004ca8:	00275783          	lhu	a5,2(a4)
    80004cac:	2785                	addiw	a5,a5,1
    80004cae:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80004cb2:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80004cb6:	100017b7          	lui	a5,0x10001
    80004cba:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80004cbe:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80004cc2:	00017917          	auipc	s2,0x17
    80004cc6:	9d690913          	addi	s2,s2,-1578 # 8001b698 <disk+0x128>
  while(b->disk == 1) {
    80004cca:	4485                	li	s1,1
    80004ccc:	01079a63          	bne	a5,a6,80004ce0 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80004cd0:	85ca                	mv	a1,s2
    80004cd2:	8552                	mv	a0,s4
    80004cd4:	e92fc0ef          	jal	80001366 <sleep>
  while(b->disk == 1) {
    80004cd8:	004a2783          	lw	a5,4(s4)
    80004cdc:	fe978ae3          	beq	a5,s1,80004cd0 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80004ce0:	f9042903          	lw	s2,-112(s0)
    80004ce4:	00290713          	addi	a4,s2,2
    80004ce8:	0712                	slli	a4,a4,0x4
    80004cea:	00017797          	auipc	a5,0x17
    80004cee:	88678793          	addi	a5,a5,-1914 # 8001b570 <disk>
    80004cf2:	97ba                	add	a5,a5,a4
    80004cf4:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80004cf8:	00017997          	auipc	s3,0x17
    80004cfc:	87898993          	addi	s3,s3,-1928 # 8001b570 <disk>
    80004d00:	00491713          	slli	a4,s2,0x4
    80004d04:	0009b783          	ld	a5,0(s3)
    80004d08:	97ba                	add	a5,a5,a4
    80004d0a:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80004d0e:	854a                	mv	a0,s2
    80004d10:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80004d14:	bafff0ef          	jal	800048c2 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80004d18:	8885                	andi	s1,s1,1
    80004d1a:	f0fd                	bnez	s1,80004d00 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80004d1c:	00017517          	auipc	a0,0x17
    80004d20:	97c50513          	addi	a0,a0,-1668 # 8001b698 <disk+0x128>
    80004d24:	405000ef          	jal	80005928 <release>
}
    80004d28:	70a6                	ld	ra,104(sp)
    80004d2a:	7406                	ld	s0,96(sp)
    80004d2c:	64e6                	ld	s1,88(sp)
    80004d2e:	6946                	ld	s2,80(sp)
    80004d30:	69a6                	ld	s3,72(sp)
    80004d32:	6a06                	ld	s4,64(sp)
    80004d34:	7ae2                	ld	s5,56(sp)
    80004d36:	7b42                	ld	s6,48(sp)
    80004d38:	7ba2                	ld	s7,40(sp)
    80004d3a:	7c02                	ld	s8,32(sp)
    80004d3c:	6ce2                	ld	s9,24(sp)
    80004d3e:	6165                	addi	sp,sp,112
    80004d40:	8082                	ret

0000000080004d42 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80004d42:	1101                	addi	sp,sp,-32
    80004d44:	ec06                	sd	ra,24(sp)
    80004d46:	e822                	sd	s0,16(sp)
    80004d48:	e426                	sd	s1,8(sp)
    80004d4a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80004d4c:	00017497          	auipc	s1,0x17
    80004d50:	82448493          	addi	s1,s1,-2012 # 8001b570 <disk>
    80004d54:	00017517          	auipc	a0,0x17
    80004d58:	94450513          	addi	a0,a0,-1724 # 8001b698 <disk+0x128>
    80004d5c:	335000ef          	jal	80005890 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80004d60:	100017b7          	lui	a5,0x10001
    80004d64:	53b8                	lw	a4,96(a5)
    80004d66:	8b0d                	andi	a4,a4,3
    80004d68:	100017b7          	lui	a5,0x10001
    80004d6c:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80004d6e:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80004d72:	689c                	ld	a5,16(s1)
    80004d74:	0204d703          	lhu	a4,32(s1)
    80004d78:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80004d7c:	04f70663          	beq	a4,a5,80004dc8 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80004d80:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80004d84:	6898                	ld	a4,16(s1)
    80004d86:	0204d783          	lhu	a5,32(s1)
    80004d8a:	8b9d                	andi	a5,a5,7
    80004d8c:	078e                	slli	a5,a5,0x3
    80004d8e:	97ba                	add	a5,a5,a4
    80004d90:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80004d92:	00278713          	addi	a4,a5,2
    80004d96:	0712                	slli	a4,a4,0x4
    80004d98:	9726                	add	a4,a4,s1
    80004d9a:	01074703          	lbu	a4,16(a4)
    80004d9e:	e321                	bnez	a4,80004dde <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80004da0:	0789                	addi	a5,a5,2
    80004da2:	0792                	slli	a5,a5,0x4
    80004da4:	97a6                	add	a5,a5,s1
    80004da6:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80004da8:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80004dac:	e06fc0ef          	jal	800013b2 <wakeup>

    disk.used_idx += 1;
    80004db0:	0204d783          	lhu	a5,32(s1)
    80004db4:	2785                	addiw	a5,a5,1
    80004db6:	17c2                	slli	a5,a5,0x30
    80004db8:	93c1                	srli	a5,a5,0x30
    80004dba:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80004dbe:	6898                	ld	a4,16(s1)
    80004dc0:	00275703          	lhu	a4,2(a4)
    80004dc4:	faf71ee3          	bne	a4,a5,80004d80 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80004dc8:	00017517          	auipc	a0,0x17
    80004dcc:	8d050513          	addi	a0,a0,-1840 # 8001b698 <disk+0x128>
    80004dd0:	359000ef          	jal	80005928 <release>
}
    80004dd4:	60e2                	ld	ra,24(sp)
    80004dd6:	6442                	ld	s0,16(sp)
    80004dd8:	64a2                	ld	s1,8(sp)
    80004dda:	6105                	addi	sp,sp,32
    80004ddc:	8082                	ret
      panic("virtio_disk_intr status");
    80004dde:	00003517          	auipc	a0,0x3
    80004de2:	9da50513          	addi	a0,a0,-1574 # 800077b8 <etext+0x7b8>
    80004de6:	77c000ef          	jal	80005562 <panic>

0000000080004dea <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    80004dea:	1141                	addi	sp,sp,-16
    80004dec:	e422                	sd	s0,8(sp)
    80004dee:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    80004df0:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80004df4:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    80004df8:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80004dfc:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80004e00:	577d                	li	a4,-1
    80004e02:	177e                	slli	a4,a4,0x3f
    80004e04:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80004e06:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    80004e0a:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80004e0e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80004e12:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    80004e16:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80004e1a:	000f4737          	lui	a4,0xf4
    80004e1e:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80004e22:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80004e24:	14d79073          	csrw	stimecmp,a5
}
    80004e28:	6422                	ld	s0,8(sp)
    80004e2a:	0141                	addi	sp,sp,16
    80004e2c:	8082                	ret

0000000080004e2e <start>:
{
    80004e2e:	1141                	addi	sp,sp,-16
    80004e30:	e406                	sd	ra,8(sp)
    80004e32:	e022                	sd	s0,0(sp)
    80004e34:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80004e36:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80004e3a:	7779                	lui	a4,0xffffe
    80004e3c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdb04f>
    80004e40:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80004e42:	6705                	lui	a4,0x1
    80004e44:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80004e48:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80004e4a:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80004e4e:	ffffb797          	auipc	a5,0xffffb
    80004e52:	4c278793          	addi	a5,a5,1218 # 80000310 <main>
    80004e56:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80004e5a:	4781                	li	a5,0
    80004e5c:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80004e60:	67c1                	lui	a5,0x10
    80004e62:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80004e64:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80004e68:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80004e6c:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80004e70:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80004e74:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80004e78:	57fd                	li	a5,-1
    80004e7a:	83a9                	srli	a5,a5,0xa
    80004e7c:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80004e80:	47bd                	li	a5,15
    80004e82:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80004e86:	f65ff0ef          	jal	80004dea <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80004e8a:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80004e8e:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80004e90:	823e                	mv	tp,a5
  asm volatile("mret");
    80004e92:	30200073          	mret
}
    80004e96:	60a2                	ld	ra,8(sp)
    80004e98:	6402                	ld	s0,0(sp)
    80004e9a:	0141                	addi	sp,sp,16
    80004e9c:	8082                	ret

0000000080004e9e <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80004e9e:	715d                	addi	sp,sp,-80
    80004ea0:	e486                	sd	ra,72(sp)
    80004ea2:	e0a2                	sd	s0,64(sp)
    80004ea4:	f84a                	sd	s2,48(sp)
    80004ea6:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80004ea8:	04c05263          	blez	a2,80004eec <consolewrite+0x4e>
    80004eac:	fc26                	sd	s1,56(sp)
    80004eae:	f44e                	sd	s3,40(sp)
    80004eb0:	f052                	sd	s4,32(sp)
    80004eb2:	ec56                	sd	s5,24(sp)
    80004eb4:	8a2a                	mv	s4,a0
    80004eb6:	84ae                	mv	s1,a1
    80004eb8:	89b2                	mv	s3,a2
    80004eba:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80004ebc:	5afd                	li	s5,-1
    80004ebe:	4685                	li	a3,1
    80004ec0:	8626                	mv	a2,s1
    80004ec2:	85d2                	mv	a1,s4
    80004ec4:	fbf40513          	addi	a0,s0,-65
    80004ec8:	845fc0ef          	jal	8000170c <either_copyin>
    80004ecc:	03550263          	beq	a0,s5,80004ef0 <consolewrite+0x52>
      break;
    uartputc(c);
    80004ed0:	fbf44503          	lbu	a0,-65(s0)
    80004ed4:	035000ef          	jal	80005708 <uartputc>
  for(i = 0; i < n; i++){
    80004ed8:	2905                	addiw	s2,s2,1
    80004eda:	0485                	addi	s1,s1,1
    80004edc:	ff2991e3          	bne	s3,s2,80004ebe <consolewrite+0x20>
    80004ee0:	894e                	mv	s2,s3
    80004ee2:	74e2                	ld	s1,56(sp)
    80004ee4:	79a2                	ld	s3,40(sp)
    80004ee6:	7a02                	ld	s4,32(sp)
    80004ee8:	6ae2                	ld	s5,24(sp)
    80004eea:	a039                	j	80004ef8 <consolewrite+0x5a>
    80004eec:	4901                	li	s2,0
    80004eee:	a029                	j	80004ef8 <consolewrite+0x5a>
    80004ef0:	74e2                	ld	s1,56(sp)
    80004ef2:	79a2                	ld	s3,40(sp)
    80004ef4:	7a02                	ld	s4,32(sp)
    80004ef6:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80004ef8:	854a                	mv	a0,s2
    80004efa:	60a6                	ld	ra,72(sp)
    80004efc:	6406                	ld	s0,64(sp)
    80004efe:	7942                	ld	s2,48(sp)
    80004f00:	6161                	addi	sp,sp,80
    80004f02:	8082                	ret

0000000080004f04 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80004f04:	711d                	addi	sp,sp,-96
    80004f06:	ec86                	sd	ra,88(sp)
    80004f08:	e8a2                	sd	s0,80(sp)
    80004f0a:	e4a6                	sd	s1,72(sp)
    80004f0c:	e0ca                	sd	s2,64(sp)
    80004f0e:	fc4e                	sd	s3,56(sp)
    80004f10:	f852                	sd	s4,48(sp)
    80004f12:	f456                	sd	s5,40(sp)
    80004f14:	f05a                	sd	s6,32(sp)
    80004f16:	1080                	addi	s0,sp,96
    80004f18:	8aaa                	mv	s5,a0
    80004f1a:	8a2e                	mv	s4,a1
    80004f1c:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80004f1e:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80004f22:	0001e517          	auipc	a0,0x1e
    80004f26:	78e50513          	addi	a0,a0,1934 # 800236b0 <cons>
    80004f2a:	167000ef          	jal	80005890 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80004f2e:	0001e497          	auipc	s1,0x1e
    80004f32:	78248493          	addi	s1,s1,1922 # 800236b0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80004f36:	0001f917          	auipc	s2,0x1f
    80004f3a:	81290913          	addi	s2,s2,-2030 # 80023748 <cons+0x98>
  while(n > 0){
    80004f3e:	0b305d63          	blez	s3,80004ff8 <consoleread+0xf4>
    while(cons.r == cons.w){
    80004f42:	0984a783          	lw	a5,152(s1)
    80004f46:	09c4a703          	lw	a4,156(s1)
    80004f4a:	0af71263          	bne	a4,a5,80004fee <consoleread+0xea>
      if(killed(myproc())){
    80004f4e:	e4bfb0ef          	jal	80000d98 <myproc>
    80004f52:	e4cfc0ef          	jal	8000159e <killed>
    80004f56:	e12d                	bnez	a0,80004fb8 <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    80004f58:	85a6                	mv	a1,s1
    80004f5a:	854a                	mv	a0,s2
    80004f5c:	c0afc0ef          	jal	80001366 <sleep>
    while(cons.r == cons.w){
    80004f60:	0984a783          	lw	a5,152(s1)
    80004f64:	09c4a703          	lw	a4,156(s1)
    80004f68:	fef703e3          	beq	a4,a5,80004f4e <consoleread+0x4a>
    80004f6c:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80004f6e:	0001e717          	auipc	a4,0x1e
    80004f72:	74270713          	addi	a4,a4,1858 # 800236b0 <cons>
    80004f76:	0017869b          	addiw	a3,a5,1
    80004f7a:	08d72c23          	sw	a3,152(a4)
    80004f7e:	07f7f693          	andi	a3,a5,127
    80004f82:	9736                	add	a4,a4,a3
    80004f84:	01874703          	lbu	a4,24(a4)
    80004f88:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80004f8c:	4691                	li	a3,4
    80004f8e:	04db8663          	beq	s7,a3,80004fda <consoleread+0xd6>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80004f92:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80004f96:	4685                	li	a3,1
    80004f98:	faf40613          	addi	a2,s0,-81
    80004f9c:	85d2                	mv	a1,s4
    80004f9e:	8556                	mv	a0,s5
    80004fa0:	f22fc0ef          	jal	800016c2 <either_copyout>
    80004fa4:	57fd                	li	a5,-1
    80004fa6:	04f50863          	beq	a0,a5,80004ff6 <consoleread+0xf2>
      break;

    dst++;
    80004faa:	0a05                	addi	s4,s4,1
    --n;
    80004fac:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80004fae:	47a9                	li	a5,10
    80004fb0:	04fb8d63          	beq	s7,a5,8000500a <consoleread+0x106>
    80004fb4:	6be2                	ld	s7,24(sp)
    80004fb6:	b761                	j	80004f3e <consoleread+0x3a>
        release(&cons.lock);
    80004fb8:	0001e517          	auipc	a0,0x1e
    80004fbc:	6f850513          	addi	a0,a0,1784 # 800236b0 <cons>
    80004fc0:	169000ef          	jal	80005928 <release>
        return -1;
    80004fc4:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80004fc6:	60e6                	ld	ra,88(sp)
    80004fc8:	6446                	ld	s0,80(sp)
    80004fca:	64a6                	ld	s1,72(sp)
    80004fcc:	6906                	ld	s2,64(sp)
    80004fce:	79e2                	ld	s3,56(sp)
    80004fd0:	7a42                	ld	s4,48(sp)
    80004fd2:	7aa2                	ld	s5,40(sp)
    80004fd4:	7b02                	ld	s6,32(sp)
    80004fd6:	6125                	addi	sp,sp,96
    80004fd8:	8082                	ret
      if(n < target){
    80004fda:	0009871b          	sext.w	a4,s3
    80004fde:	01677a63          	bgeu	a4,s6,80004ff2 <consoleread+0xee>
        cons.r--;
    80004fe2:	0001e717          	auipc	a4,0x1e
    80004fe6:	76f72323          	sw	a5,1894(a4) # 80023748 <cons+0x98>
    80004fea:	6be2                	ld	s7,24(sp)
    80004fec:	a031                	j	80004ff8 <consoleread+0xf4>
    80004fee:	ec5e                	sd	s7,24(sp)
    80004ff0:	bfbd                	j	80004f6e <consoleread+0x6a>
    80004ff2:	6be2                	ld	s7,24(sp)
    80004ff4:	a011                	j	80004ff8 <consoleread+0xf4>
    80004ff6:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80004ff8:	0001e517          	auipc	a0,0x1e
    80004ffc:	6b850513          	addi	a0,a0,1720 # 800236b0 <cons>
    80005000:	129000ef          	jal	80005928 <release>
  return target - n;
    80005004:	413b053b          	subw	a0,s6,s3
    80005008:	bf7d                	j	80004fc6 <consoleread+0xc2>
    8000500a:	6be2                	ld	s7,24(sp)
    8000500c:	b7f5                	j	80004ff8 <consoleread+0xf4>

000000008000500e <consputc>:
{
    8000500e:	1141                	addi	sp,sp,-16
    80005010:	e406                	sd	ra,8(sp)
    80005012:	e022                	sd	s0,0(sp)
    80005014:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005016:	10000793          	li	a5,256
    8000501a:	00f50863          	beq	a0,a5,8000502a <consputc+0x1c>
    uartputc_sync(c);
    8000501e:	604000ef          	jal	80005622 <uartputc_sync>
}
    80005022:	60a2                	ld	ra,8(sp)
    80005024:	6402                	ld	s0,0(sp)
    80005026:	0141                	addi	sp,sp,16
    80005028:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    8000502a:	4521                	li	a0,8
    8000502c:	5f6000ef          	jal	80005622 <uartputc_sync>
    80005030:	02000513          	li	a0,32
    80005034:	5ee000ef          	jal	80005622 <uartputc_sync>
    80005038:	4521                	li	a0,8
    8000503a:	5e8000ef          	jal	80005622 <uartputc_sync>
    8000503e:	b7d5                	j	80005022 <consputc+0x14>

0000000080005040 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005040:	1101                	addi	sp,sp,-32
    80005042:	ec06                	sd	ra,24(sp)
    80005044:	e822                	sd	s0,16(sp)
    80005046:	e426                	sd	s1,8(sp)
    80005048:	1000                	addi	s0,sp,32
    8000504a:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    8000504c:	0001e517          	auipc	a0,0x1e
    80005050:	66450513          	addi	a0,a0,1636 # 800236b0 <cons>
    80005054:	03d000ef          	jal	80005890 <acquire>

  switch(c){
    80005058:	47d5                	li	a5,21
    8000505a:	08f48f63          	beq	s1,a5,800050f8 <consoleintr+0xb8>
    8000505e:	0297c563          	blt	a5,s1,80005088 <consoleintr+0x48>
    80005062:	47a1                	li	a5,8
    80005064:	0ef48463          	beq	s1,a5,8000514c <consoleintr+0x10c>
    80005068:	47c1                	li	a5,16
    8000506a:	10f49563          	bne	s1,a5,80005174 <consoleintr+0x134>
  case C('P'):  // Print process list.
    procdump();
    8000506e:	ee8fc0ef          	jal	80001756 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005072:	0001e517          	auipc	a0,0x1e
    80005076:	63e50513          	addi	a0,a0,1598 # 800236b0 <cons>
    8000507a:	0af000ef          	jal	80005928 <release>
}
    8000507e:	60e2                	ld	ra,24(sp)
    80005080:	6442                	ld	s0,16(sp)
    80005082:	64a2                	ld	s1,8(sp)
    80005084:	6105                	addi	sp,sp,32
    80005086:	8082                	ret
  switch(c){
    80005088:	07f00793          	li	a5,127
    8000508c:	0cf48063          	beq	s1,a5,8000514c <consoleintr+0x10c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005090:	0001e717          	auipc	a4,0x1e
    80005094:	62070713          	addi	a4,a4,1568 # 800236b0 <cons>
    80005098:	0a072783          	lw	a5,160(a4)
    8000509c:	09872703          	lw	a4,152(a4)
    800050a0:	9f99                	subw	a5,a5,a4
    800050a2:	07f00713          	li	a4,127
    800050a6:	fcf766e3          	bltu	a4,a5,80005072 <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    800050aa:	47b5                	li	a5,13
    800050ac:	0cf48763          	beq	s1,a5,8000517a <consoleintr+0x13a>
      consputc(c);
    800050b0:	8526                	mv	a0,s1
    800050b2:	f5dff0ef          	jal	8000500e <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800050b6:	0001e797          	auipc	a5,0x1e
    800050ba:	5fa78793          	addi	a5,a5,1530 # 800236b0 <cons>
    800050be:	0a07a683          	lw	a3,160(a5)
    800050c2:	0016871b          	addiw	a4,a3,1
    800050c6:	0007061b          	sext.w	a2,a4
    800050ca:	0ae7a023          	sw	a4,160(a5)
    800050ce:	07f6f693          	andi	a3,a3,127
    800050d2:	97b6                	add	a5,a5,a3
    800050d4:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    800050d8:	47a9                	li	a5,10
    800050da:	0cf48563          	beq	s1,a5,800051a4 <consoleintr+0x164>
    800050de:	4791                	li	a5,4
    800050e0:	0cf48263          	beq	s1,a5,800051a4 <consoleintr+0x164>
    800050e4:	0001e797          	auipc	a5,0x1e
    800050e8:	6647a783          	lw	a5,1636(a5) # 80023748 <cons+0x98>
    800050ec:	9f1d                	subw	a4,a4,a5
    800050ee:	08000793          	li	a5,128
    800050f2:	f8f710e3          	bne	a4,a5,80005072 <consoleintr+0x32>
    800050f6:	a07d                	j	800051a4 <consoleintr+0x164>
    800050f8:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    800050fa:	0001e717          	auipc	a4,0x1e
    800050fe:	5b670713          	addi	a4,a4,1462 # 800236b0 <cons>
    80005102:	0a072783          	lw	a5,160(a4)
    80005106:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000510a:	0001e497          	auipc	s1,0x1e
    8000510e:	5a648493          	addi	s1,s1,1446 # 800236b0 <cons>
    while(cons.e != cons.w &&
    80005112:	4929                	li	s2,10
    80005114:	02f70863          	beq	a4,a5,80005144 <consoleintr+0x104>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005118:	37fd                	addiw	a5,a5,-1
    8000511a:	07f7f713          	andi	a4,a5,127
    8000511e:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005120:	01874703          	lbu	a4,24(a4)
    80005124:	03270263          	beq	a4,s2,80005148 <consoleintr+0x108>
      cons.e--;
    80005128:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    8000512c:	10000513          	li	a0,256
    80005130:	edfff0ef          	jal	8000500e <consputc>
    while(cons.e != cons.w &&
    80005134:	0a04a783          	lw	a5,160(s1)
    80005138:	09c4a703          	lw	a4,156(s1)
    8000513c:	fcf71ee3          	bne	a4,a5,80005118 <consoleintr+0xd8>
    80005140:	6902                	ld	s2,0(sp)
    80005142:	bf05                	j	80005072 <consoleintr+0x32>
    80005144:	6902                	ld	s2,0(sp)
    80005146:	b735                	j	80005072 <consoleintr+0x32>
    80005148:	6902                	ld	s2,0(sp)
    8000514a:	b725                	j	80005072 <consoleintr+0x32>
    if(cons.e != cons.w){
    8000514c:	0001e717          	auipc	a4,0x1e
    80005150:	56470713          	addi	a4,a4,1380 # 800236b0 <cons>
    80005154:	0a072783          	lw	a5,160(a4)
    80005158:	09c72703          	lw	a4,156(a4)
    8000515c:	f0f70be3          	beq	a4,a5,80005072 <consoleintr+0x32>
      cons.e--;
    80005160:	37fd                	addiw	a5,a5,-1
    80005162:	0001e717          	auipc	a4,0x1e
    80005166:	5ef72723          	sw	a5,1518(a4) # 80023750 <cons+0xa0>
      consputc(BACKSPACE);
    8000516a:	10000513          	li	a0,256
    8000516e:	ea1ff0ef          	jal	8000500e <consputc>
    80005172:	b701                	j	80005072 <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005174:	ee048fe3          	beqz	s1,80005072 <consoleintr+0x32>
    80005178:	bf21                	j	80005090 <consoleintr+0x50>
      consputc(c);
    8000517a:	4529                	li	a0,10
    8000517c:	e93ff0ef          	jal	8000500e <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005180:	0001e797          	auipc	a5,0x1e
    80005184:	53078793          	addi	a5,a5,1328 # 800236b0 <cons>
    80005188:	0a07a703          	lw	a4,160(a5)
    8000518c:	0017069b          	addiw	a3,a4,1
    80005190:	0006861b          	sext.w	a2,a3
    80005194:	0ad7a023          	sw	a3,160(a5)
    80005198:	07f77713          	andi	a4,a4,127
    8000519c:	97ba                	add	a5,a5,a4
    8000519e:	4729                	li	a4,10
    800051a0:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    800051a4:	0001e797          	auipc	a5,0x1e
    800051a8:	5ac7a423          	sw	a2,1448(a5) # 8002374c <cons+0x9c>
        wakeup(&cons.r);
    800051ac:	0001e517          	auipc	a0,0x1e
    800051b0:	59c50513          	addi	a0,a0,1436 # 80023748 <cons+0x98>
    800051b4:	9fefc0ef          	jal	800013b2 <wakeup>
    800051b8:	bd6d                	j	80005072 <consoleintr+0x32>

00000000800051ba <consoleinit>:

void
consoleinit(void)
{
    800051ba:	1141                	addi	sp,sp,-16
    800051bc:	e406                	sd	ra,8(sp)
    800051be:	e022                	sd	s0,0(sp)
    800051c0:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    800051c2:	00002597          	auipc	a1,0x2
    800051c6:	60e58593          	addi	a1,a1,1550 # 800077d0 <etext+0x7d0>
    800051ca:	0001e517          	auipc	a0,0x1e
    800051ce:	4e650513          	addi	a0,a0,1254 # 800236b0 <cons>
    800051d2:	63e000ef          	jal	80005810 <initlock>

  uartinit();
    800051d6:	3f4000ef          	jal	800055ca <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    800051da:	00015797          	auipc	a5,0x15
    800051de:	33e78793          	addi	a5,a5,830 # 8001a518 <devsw>
    800051e2:	00000717          	auipc	a4,0x0
    800051e6:	d2270713          	addi	a4,a4,-734 # 80004f04 <consoleread>
    800051ea:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    800051ec:	00000717          	auipc	a4,0x0
    800051f0:	cb270713          	addi	a4,a4,-846 # 80004e9e <consolewrite>
    800051f4:	ef98                	sd	a4,24(a5)
}
    800051f6:	60a2                	ld	ra,8(sp)
    800051f8:	6402                	ld	s0,0(sp)
    800051fa:	0141                	addi	sp,sp,16
    800051fc:	8082                	ret

00000000800051fe <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    800051fe:	7179                	addi	sp,sp,-48
    80005200:	f406                	sd	ra,40(sp)
    80005202:	f022                	sd	s0,32(sp)
    80005204:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    80005206:	c219                	beqz	a2,8000520c <printint+0xe>
    80005208:	08054063          	bltz	a0,80005288 <printint+0x8a>
    x = -xx;
  else
    x = xx;
    8000520c:	4881                	li	a7,0
    8000520e:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005212:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    80005214:	00002617          	auipc	a2,0x2
    80005218:	7e460613          	addi	a2,a2,2020 # 800079f8 <digits>
    8000521c:	883e                	mv	a6,a5
    8000521e:	2785                	addiw	a5,a5,1
    80005220:	02b57733          	remu	a4,a0,a1
    80005224:	9732                	add	a4,a4,a2
    80005226:	00074703          	lbu	a4,0(a4)
    8000522a:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    8000522e:	872a                	mv	a4,a0
    80005230:	02b55533          	divu	a0,a0,a1
    80005234:	0685                	addi	a3,a3,1
    80005236:	feb773e3          	bgeu	a4,a1,8000521c <printint+0x1e>

  if(sign)
    8000523a:	00088a63          	beqz	a7,8000524e <printint+0x50>
    buf[i++] = '-';
    8000523e:	1781                	addi	a5,a5,-32
    80005240:	97a2                	add	a5,a5,s0
    80005242:	02d00713          	li	a4,45
    80005246:	fee78823          	sb	a4,-16(a5)
    8000524a:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    8000524e:	02f05963          	blez	a5,80005280 <printint+0x82>
    80005252:	ec26                	sd	s1,24(sp)
    80005254:	e84a                	sd	s2,16(sp)
    80005256:	fd040713          	addi	a4,s0,-48
    8000525a:	00f704b3          	add	s1,a4,a5
    8000525e:	fff70913          	addi	s2,a4,-1
    80005262:	993e                	add	s2,s2,a5
    80005264:	37fd                	addiw	a5,a5,-1
    80005266:	1782                	slli	a5,a5,0x20
    80005268:	9381                	srli	a5,a5,0x20
    8000526a:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    8000526e:	fff4c503          	lbu	a0,-1(s1)
    80005272:	d9dff0ef          	jal	8000500e <consputc>
  while(--i >= 0)
    80005276:	14fd                	addi	s1,s1,-1
    80005278:	ff249be3          	bne	s1,s2,8000526e <printint+0x70>
    8000527c:	64e2                	ld	s1,24(sp)
    8000527e:	6942                	ld	s2,16(sp)
}
    80005280:	70a2                	ld	ra,40(sp)
    80005282:	7402                	ld	s0,32(sp)
    80005284:	6145                	addi	sp,sp,48
    80005286:	8082                	ret
    x = -xx;
    80005288:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    8000528c:	4885                	li	a7,1
    x = -xx;
    8000528e:	b741                	j	8000520e <printint+0x10>

0000000080005290 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    80005290:	7155                	addi	sp,sp,-208
    80005292:	e506                	sd	ra,136(sp)
    80005294:	e122                	sd	s0,128(sp)
    80005296:	f0d2                	sd	s4,96(sp)
    80005298:	0900                	addi	s0,sp,144
    8000529a:	8a2a                	mv	s4,a0
    8000529c:	e40c                	sd	a1,8(s0)
    8000529e:	e810                	sd	a2,16(s0)
    800052a0:	ec14                	sd	a3,24(s0)
    800052a2:	f018                	sd	a4,32(s0)
    800052a4:	f41c                	sd	a5,40(s0)
    800052a6:	03043823          	sd	a6,48(s0)
    800052aa:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    800052ae:	0001e797          	auipc	a5,0x1e
    800052b2:	4c27a783          	lw	a5,1218(a5) # 80023770 <pr+0x18>
    800052b6:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    800052ba:	e3a1                	bnez	a5,800052fa <printf+0x6a>
    acquire(&pr.lock);

  va_start(ap, fmt);
    800052bc:	00840793          	addi	a5,s0,8
    800052c0:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800052c4:	00054503          	lbu	a0,0(a0)
    800052c8:	26050763          	beqz	a0,80005536 <printf+0x2a6>
    800052cc:	fca6                	sd	s1,120(sp)
    800052ce:	f8ca                	sd	s2,112(sp)
    800052d0:	f4ce                	sd	s3,104(sp)
    800052d2:	ecd6                	sd	s5,88(sp)
    800052d4:	e8da                	sd	s6,80(sp)
    800052d6:	e0e2                	sd	s8,64(sp)
    800052d8:	fc66                	sd	s9,56(sp)
    800052da:	f86a                	sd	s10,48(sp)
    800052dc:	f46e                	sd	s11,40(sp)
    800052de:	4981                	li	s3,0
    if(cx != '%'){
    800052e0:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    800052e4:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    800052e8:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    800052ec:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    800052f0:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    800052f4:	07000d93          	li	s11,112
    800052f8:	a815                	j	8000532c <printf+0x9c>
    acquire(&pr.lock);
    800052fa:	0001e517          	auipc	a0,0x1e
    800052fe:	45e50513          	addi	a0,a0,1118 # 80023758 <pr>
    80005302:	58e000ef          	jal	80005890 <acquire>
  va_start(ap, fmt);
    80005306:	00840793          	addi	a5,s0,8
    8000530a:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000530e:	000a4503          	lbu	a0,0(s4)
    80005312:	fd4d                	bnez	a0,800052cc <printf+0x3c>
    80005314:	a481                	j	80005554 <printf+0x2c4>
      consputc(cx);
    80005316:	cf9ff0ef          	jal	8000500e <consputc>
      continue;
    8000531a:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000531c:	0014899b          	addiw	s3,s1,1
    80005320:	013a07b3          	add	a5,s4,s3
    80005324:	0007c503          	lbu	a0,0(a5)
    80005328:	1e050b63          	beqz	a0,8000551e <printf+0x28e>
    if(cx != '%'){
    8000532c:	ff5515e3          	bne	a0,s5,80005316 <printf+0x86>
    i++;
    80005330:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    80005334:	009a07b3          	add	a5,s4,s1
    80005338:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    8000533c:	1e090163          	beqz	s2,8000551e <printf+0x28e>
    80005340:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    80005344:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    80005346:	c789                	beqz	a5,80005350 <printf+0xc0>
    80005348:	009a0733          	add	a4,s4,s1
    8000534c:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    80005350:	03690763          	beq	s2,s6,8000537e <printf+0xee>
    } else if(c0 == 'l' && c1 == 'd'){
    80005354:	05890163          	beq	s2,s8,80005396 <printf+0x106>
    } else if(c0 == 'u'){
    80005358:	0d990b63          	beq	s2,s9,8000542e <printf+0x19e>
    } else if(c0 == 'x'){
    8000535c:	13a90163          	beq	s2,s10,8000547e <printf+0x1ee>
    } else if(c0 == 'p'){
    80005360:	13b90b63          	beq	s2,s11,80005496 <printf+0x206>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 's'){
    80005364:	07300793          	li	a5,115
    80005368:	16f90a63          	beq	s2,a5,800054dc <printf+0x24c>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    8000536c:	1b590463          	beq	s2,s5,80005514 <printf+0x284>
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    80005370:	8556                	mv	a0,s5
    80005372:	c9dff0ef          	jal	8000500e <consputc>
      consputc(c0);
    80005376:	854a                	mv	a0,s2
    80005378:	c97ff0ef          	jal	8000500e <consputc>
    8000537c:	b745                	j	8000531c <printf+0x8c>
      printint(va_arg(ap, int), 10, 1);
    8000537e:	f8843783          	ld	a5,-120(s0)
    80005382:	00878713          	addi	a4,a5,8
    80005386:	f8e43423          	sd	a4,-120(s0)
    8000538a:	4605                	li	a2,1
    8000538c:	45a9                	li	a1,10
    8000538e:	4388                	lw	a0,0(a5)
    80005390:	e6fff0ef          	jal	800051fe <printint>
    80005394:	b761                	j	8000531c <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'd'){
    80005396:	03678663          	beq	a5,s6,800053c2 <printf+0x132>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000539a:	05878263          	beq	a5,s8,800053de <printf+0x14e>
    } else if(c0 == 'l' && c1 == 'u'){
    8000539e:	0b978463          	beq	a5,s9,80005446 <printf+0x1b6>
    } else if(c0 == 'l' && c1 == 'x'){
    800053a2:	fda797e3          	bne	a5,s10,80005370 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    800053a6:	f8843783          	ld	a5,-120(s0)
    800053aa:	00878713          	addi	a4,a5,8
    800053ae:	f8e43423          	sd	a4,-120(s0)
    800053b2:	4601                	li	a2,0
    800053b4:	45c1                	li	a1,16
    800053b6:	6388                	ld	a0,0(a5)
    800053b8:	e47ff0ef          	jal	800051fe <printint>
      i += 1;
    800053bc:	0029849b          	addiw	s1,s3,2
    800053c0:	bfb1                	j	8000531c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    800053c2:	f8843783          	ld	a5,-120(s0)
    800053c6:	00878713          	addi	a4,a5,8
    800053ca:	f8e43423          	sd	a4,-120(s0)
    800053ce:	4605                	li	a2,1
    800053d0:	45a9                	li	a1,10
    800053d2:	6388                	ld	a0,0(a5)
    800053d4:	e2bff0ef          	jal	800051fe <printint>
      i += 1;
    800053d8:	0029849b          	addiw	s1,s3,2
    800053dc:	b781                	j	8000531c <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800053de:	06400793          	li	a5,100
    800053e2:	02f68863          	beq	a3,a5,80005412 <printf+0x182>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    800053e6:	07500793          	li	a5,117
    800053ea:	06f68c63          	beq	a3,a5,80005462 <printf+0x1d2>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    800053ee:	07800793          	li	a5,120
    800053f2:	f6f69fe3          	bne	a3,a5,80005370 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    800053f6:	f8843783          	ld	a5,-120(s0)
    800053fa:	00878713          	addi	a4,a5,8
    800053fe:	f8e43423          	sd	a4,-120(s0)
    80005402:	4601                	li	a2,0
    80005404:	45c1                	li	a1,16
    80005406:	6388                	ld	a0,0(a5)
    80005408:	df7ff0ef          	jal	800051fe <printint>
      i += 2;
    8000540c:	0039849b          	addiw	s1,s3,3
    80005410:	b731                	j	8000531c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80005412:	f8843783          	ld	a5,-120(s0)
    80005416:	00878713          	addi	a4,a5,8
    8000541a:	f8e43423          	sd	a4,-120(s0)
    8000541e:	4605                	li	a2,1
    80005420:	45a9                	li	a1,10
    80005422:	6388                	ld	a0,0(a5)
    80005424:	ddbff0ef          	jal	800051fe <printint>
      i += 2;
    80005428:	0039849b          	addiw	s1,s3,3
    8000542c:	bdc5                	j	8000531c <printf+0x8c>
      printint(va_arg(ap, int), 10, 0);
    8000542e:	f8843783          	ld	a5,-120(s0)
    80005432:	00878713          	addi	a4,a5,8
    80005436:	f8e43423          	sd	a4,-120(s0)
    8000543a:	4601                	li	a2,0
    8000543c:	45a9                	li	a1,10
    8000543e:	4388                	lw	a0,0(a5)
    80005440:	dbfff0ef          	jal	800051fe <printint>
    80005444:	bde1                	j	8000531c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    80005446:	f8843783          	ld	a5,-120(s0)
    8000544a:	00878713          	addi	a4,a5,8
    8000544e:	f8e43423          	sd	a4,-120(s0)
    80005452:	4601                	li	a2,0
    80005454:	45a9                	li	a1,10
    80005456:	6388                	ld	a0,0(a5)
    80005458:	da7ff0ef          	jal	800051fe <printint>
      i += 1;
    8000545c:	0029849b          	addiw	s1,s3,2
    80005460:	bd75                	j	8000531c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    80005462:	f8843783          	ld	a5,-120(s0)
    80005466:	00878713          	addi	a4,a5,8
    8000546a:	f8e43423          	sd	a4,-120(s0)
    8000546e:	4601                	li	a2,0
    80005470:	45a9                	li	a1,10
    80005472:	6388                	ld	a0,0(a5)
    80005474:	d8bff0ef          	jal	800051fe <printint>
      i += 2;
    80005478:	0039849b          	addiw	s1,s3,3
    8000547c:	b545                	j	8000531c <printf+0x8c>
      printint(va_arg(ap, int), 16, 0);
    8000547e:	f8843783          	ld	a5,-120(s0)
    80005482:	00878713          	addi	a4,a5,8
    80005486:	f8e43423          	sd	a4,-120(s0)
    8000548a:	4601                	li	a2,0
    8000548c:	45c1                	li	a1,16
    8000548e:	4388                	lw	a0,0(a5)
    80005490:	d6fff0ef          	jal	800051fe <printint>
    80005494:	b561                	j	8000531c <printf+0x8c>
    80005496:	e4de                	sd	s7,72(sp)
      printptr(va_arg(ap, uint64));
    80005498:	f8843783          	ld	a5,-120(s0)
    8000549c:	00878713          	addi	a4,a5,8
    800054a0:	f8e43423          	sd	a4,-120(s0)
    800054a4:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800054a8:	03000513          	li	a0,48
    800054ac:	b63ff0ef          	jal	8000500e <consputc>
  consputc('x');
    800054b0:	07800513          	li	a0,120
    800054b4:	b5bff0ef          	jal	8000500e <consputc>
    800054b8:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800054ba:	00002b97          	auipc	s7,0x2
    800054be:	53eb8b93          	addi	s7,s7,1342 # 800079f8 <digits>
    800054c2:	03c9d793          	srli	a5,s3,0x3c
    800054c6:	97de                	add	a5,a5,s7
    800054c8:	0007c503          	lbu	a0,0(a5)
    800054cc:	b43ff0ef          	jal	8000500e <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800054d0:	0992                	slli	s3,s3,0x4
    800054d2:	397d                	addiw	s2,s2,-1
    800054d4:	fe0917e3          	bnez	s2,800054c2 <printf+0x232>
    800054d8:	6ba6                	ld	s7,72(sp)
    800054da:	b589                	j	8000531c <printf+0x8c>
      if((s = va_arg(ap, char*)) == 0)
    800054dc:	f8843783          	ld	a5,-120(s0)
    800054e0:	00878713          	addi	a4,a5,8
    800054e4:	f8e43423          	sd	a4,-120(s0)
    800054e8:	0007b903          	ld	s2,0(a5)
    800054ec:	00090d63          	beqz	s2,80005506 <printf+0x276>
      for(; *s; s++)
    800054f0:	00094503          	lbu	a0,0(s2)
    800054f4:	e20504e3          	beqz	a0,8000531c <printf+0x8c>
        consputc(*s);
    800054f8:	b17ff0ef          	jal	8000500e <consputc>
      for(; *s; s++)
    800054fc:	0905                	addi	s2,s2,1
    800054fe:	00094503          	lbu	a0,0(s2)
    80005502:	f97d                	bnez	a0,800054f8 <printf+0x268>
    80005504:	bd21                	j	8000531c <printf+0x8c>
        s = "(null)";
    80005506:	00002917          	auipc	s2,0x2
    8000550a:	2d290913          	addi	s2,s2,722 # 800077d8 <etext+0x7d8>
      for(; *s; s++)
    8000550e:	02800513          	li	a0,40
    80005512:	b7dd                	j	800054f8 <printf+0x268>
      consputc('%');
    80005514:	02500513          	li	a0,37
    80005518:	af7ff0ef          	jal	8000500e <consputc>
    8000551c:	b501                	j	8000531c <printf+0x8c>
    }
#endif
  }
  va_end(ap);

  if(locking)
    8000551e:	f7843783          	ld	a5,-136(s0)
    80005522:	e385                	bnez	a5,80005542 <printf+0x2b2>
    80005524:	74e6                	ld	s1,120(sp)
    80005526:	7946                	ld	s2,112(sp)
    80005528:	79a6                	ld	s3,104(sp)
    8000552a:	6ae6                	ld	s5,88(sp)
    8000552c:	6b46                	ld	s6,80(sp)
    8000552e:	6c06                	ld	s8,64(sp)
    80005530:	7ce2                	ld	s9,56(sp)
    80005532:	7d42                	ld	s10,48(sp)
    80005534:	7da2                	ld	s11,40(sp)
    release(&pr.lock);

  return 0;
}
    80005536:	4501                	li	a0,0
    80005538:	60aa                	ld	ra,136(sp)
    8000553a:	640a                	ld	s0,128(sp)
    8000553c:	7a06                	ld	s4,96(sp)
    8000553e:	6169                	addi	sp,sp,208
    80005540:	8082                	ret
    80005542:	74e6                	ld	s1,120(sp)
    80005544:	7946                	ld	s2,112(sp)
    80005546:	79a6                	ld	s3,104(sp)
    80005548:	6ae6                	ld	s5,88(sp)
    8000554a:	6b46                	ld	s6,80(sp)
    8000554c:	6c06                	ld	s8,64(sp)
    8000554e:	7ce2                	ld	s9,56(sp)
    80005550:	7d42                	ld	s10,48(sp)
    80005552:	7da2                	ld	s11,40(sp)
    release(&pr.lock);
    80005554:	0001e517          	auipc	a0,0x1e
    80005558:	20450513          	addi	a0,a0,516 # 80023758 <pr>
    8000555c:	3cc000ef          	jal	80005928 <release>
    80005560:	bfd9                	j	80005536 <printf+0x2a6>

0000000080005562 <panic>:

void
panic(char *s)
{
    80005562:	1101                	addi	sp,sp,-32
    80005564:	ec06                	sd	ra,24(sp)
    80005566:	e822                	sd	s0,16(sp)
    80005568:	e426                	sd	s1,8(sp)
    8000556a:	1000                	addi	s0,sp,32
    8000556c:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000556e:	0001e797          	auipc	a5,0x1e
    80005572:	2007a123          	sw	zero,514(a5) # 80023770 <pr+0x18>
  printf("panic: ");
    80005576:	00002517          	auipc	a0,0x2
    8000557a:	26a50513          	addi	a0,a0,618 # 800077e0 <etext+0x7e0>
    8000557e:	d13ff0ef          	jal	80005290 <printf>
  printf("%s\n", s);
    80005582:	85a6                	mv	a1,s1
    80005584:	00002517          	auipc	a0,0x2
    80005588:	26450513          	addi	a0,a0,612 # 800077e8 <etext+0x7e8>
    8000558c:	d05ff0ef          	jal	80005290 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005590:	4785                	li	a5,1
    80005592:	00005717          	auipc	a4,0x5
    80005596:	ecf72d23          	sw	a5,-294(a4) # 8000a46c <panicked>
  for(;;)
    8000559a:	a001                	j	8000559a <panic+0x38>

000000008000559c <printfinit>:
    ;
}

void
printfinit(void)
{
    8000559c:	1101                	addi	sp,sp,-32
    8000559e:	ec06                	sd	ra,24(sp)
    800055a0:	e822                	sd	s0,16(sp)
    800055a2:	e426                	sd	s1,8(sp)
    800055a4:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800055a6:	0001e497          	auipc	s1,0x1e
    800055aa:	1b248493          	addi	s1,s1,434 # 80023758 <pr>
    800055ae:	00002597          	auipc	a1,0x2
    800055b2:	24258593          	addi	a1,a1,578 # 800077f0 <etext+0x7f0>
    800055b6:	8526                	mv	a0,s1
    800055b8:	258000ef          	jal	80005810 <initlock>
  pr.locking = 1;
    800055bc:	4785                	li	a5,1
    800055be:	cc9c                	sw	a5,24(s1)
}
    800055c0:	60e2                	ld	ra,24(sp)
    800055c2:	6442                	ld	s0,16(sp)
    800055c4:	64a2                	ld	s1,8(sp)
    800055c6:	6105                	addi	sp,sp,32
    800055c8:	8082                	ret

00000000800055ca <uartinit>:

void uartstart();

void
uartinit(void)
{
    800055ca:	1141                	addi	sp,sp,-16
    800055cc:	e406                	sd	ra,8(sp)
    800055ce:	e022                	sd	s0,0(sp)
    800055d0:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800055d2:	100007b7          	lui	a5,0x10000
    800055d6:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800055da:	10000737          	lui	a4,0x10000
    800055de:	f8000693          	li	a3,-128
    800055e2:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800055e6:	468d                	li	a3,3
    800055e8:	10000637          	lui	a2,0x10000
    800055ec:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800055f0:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800055f4:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800055f8:	10000737          	lui	a4,0x10000
    800055fc:	461d                	li	a2,7
    800055fe:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005602:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005606:	00002597          	auipc	a1,0x2
    8000560a:	1f258593          	addi	a1,a1,498 # 800077f8 <etext+0x7f8>
    8000560e:	0001e517          	auipc	a0,0x1e
    80005612:	16a50513          	addi	a0,a0,362 # 80023778 <uart_tx_lock>
    80005616:	1fa000ef          	jal	80005810 <initlock>
}
    8000561a:	60a2                	ld	ra,8(sp)
    8000561c:	6402                	ld	s0,0(sp)
    8000561e:	0141                	addi	sp,sp,16
    80005620:	8082                	ret

0000000080005622 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005622:	1101                	addi	sp,sp,-32
    80005624:	ec06                	sd	ra,24(sp)
    80005626:	e822                	sd	s0,16(sp)
    80005628:	e426                	sd	s1,8(sp)
    8000562a:	1000                	addi	s0,sp,32
    8000562c:	84aa                	mv	s1,a0
  push_off();
    8000562e:	222000ef          	jal	80005850 <push_off>

  if(panicked){
    80005632:	00005797          	auipc	a5,0x5
    80005636:	e3a7a783          	lw	a5,-454(a5) # 8000a46c <panicked>
    8000563a:	e795                	bnez	a5,80005666 <uartputc_sync+0x44>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000563c:	10000737          	lui	a4,0x10000
    80005640:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80005642:	00074783          	lbu	a5,0(a4)
    80005646:	0207f793          	andi	a5,a5,32
    8000564a:	dfe5                	beqz	a5,80005642 <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    8000564c:	0ff4f513          	zext.b	a0,s1
    80005650:	100007b7          	lui	a5,0x10000
    80005654:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005658:	27c000ef          	jal	800058d4 <pop_off>
}
    8000565c:	60e2                	ld	ra,24(sp)
    8000565e:	6442                	ld	s0,16(sp)
    80005660:	64a2                	ld	s1,8(sp)
    80005662:	6105                	addi	sp,sp,32
    80005664:	8082                	ret
    for(;;)
    80005666:	a001                	j	80005666 <uartputc_sync+0x44>

0000000080005668 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005668:	00005797          	auipc	a5,0x5
    8000566c:	e087b783          	ld	a5,-504(a5) # 8000a470 <uart_tx_r>
    80005670:	00005717          	auipc	a4,0x5
    80005674:	e0873703          	ld	a4,-504(a4) # 8000a478 <uart_tx_w>
    80005678:	08f70263          	beq	a4,a5,800056fc <uartstart+0x94>
{
    8000567c:	7139                	addi	sp,sp,-64
    8000567e:	fc06                	sd	ra,56(sp)
    80005680:	f822                	sd	s0,48(sp)
    80005682:	f426                	sd	s1,40(sp)
    80005684:	f04a                	sd	s2,32(sp)
    80005686:	ec4e                	sd	s3,24(sp)
    80005688:	e852                	sd	s4,16(sp)
    8000568a:	e456                	sd	s5,8(sp)
    8000568c:	e05a                	sd	s6,0(sp)
    8000568e:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005690:	10000937          	lui	s2,0x10000
    80005694:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005696:	0001ea97          	auipc	s5,0x1e
    8000569a:	0e2a8a93          	addi	s5,s5,226 # 80023778 <uart_tx_lock>
    uart_tx_r += 1;
    8000569e:	00005497          	auipc	s1,0x5
    800056a2:	dd248493          	addi	s1,s1,-558 # 8000a470 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800056a6:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800056aa:	00005997          	auipc	s3,0x5
    800056ae:	dce98993          	addi	s3,s3,-562 # 8000a478 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800056b2:	00094703          	lbu	a4,0(s2)
    800056b6:	02077713          	andi	a4,a4,32
    800056ba:	c71d                	beqz	a4,800056e8 <uartstart+0x80>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800056bc:	01f7f713          	andi	a4,a5,31
    800056c0:	9756                	add	a4,a4,s5
    800056c2:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    800056c6:	0785                	addi	a5,a5,1
    800056c8:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    800056ca:	8526                	mv	a0,s1
    800056cc:	ce7fb0ef          	jal	800013b2 <wakeup>
    WriteReg(THR, c);
    800056d0:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    800056d4:	609c                	ld	a5,0(s1)
    800056d6:	0009b703          	ld	a4,0(s3)
    800056da:	fcf71ce3          	bne	a4,a5,800056b2 <uartstart+0x4a>
      ReadReg(ISR);
    800056de:	100007b7          	lui	a5,0x10000
    800056e2:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    800056e4:	0007c783          	lbu	a5,0(a5)
  }
}
    800056e8:	70e2                	ld	ra,56(sp)
    800056ea:	7442                	ld	s0,48(sp)
    800056ec:	74a2                	ld	s1,40(sp)
    800056ee:	7902                	ld	s2,32(sp)
    800056f0:	69e2                	ld	s3,24(sp)
    800056f2:	6a42                	ld	s4,16(sp)
    800056f4:	6aa2                	ld	s5,8(sp)
    800056f6:	6b02                	ld	s6,0(sp)
    800056f8:	6121                	addi	sp,sp,64
    800056fa:	8082                	ret
      ReadReg(ISR);
    800056fc:	100007b7          	lui	a5,0x10000
    80005700:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80005702:	0007c783          	lbu	a5,0(a5)
      return;
    80005706:	8082                	ret

0000000080005708 <uartputc>:
{
    80005708:	7179                	addi	sp,sp,-48
    8000570a:	f406                	sd	ra,40(sp)
    8000570c:	f022                	sd	s0,32(sp)
    8000570e:	ec26                	sd	s1,24(sp)
    80005710:	e84a                	sd	s2,16(sp)
    80005712:	e44e                	sd	s3,8(sp)
    80005714:	e052                	sd	s4,0(sp)
    80005716:	1800                	addi	s0,sp,48
    80005718:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    8000571a:	0001e517          	auipc	a0,0x1e
    8000571e:	05e50513          	addi	a0,a0,94 # 80023778 <uart_tx_lock>
    80005722:	16e000ef          	jal	80005890 <acquire>
  if(panicked){
    80005726:	00005797          	auipc	a5,0x5
    8000572a:	d467a783          	lw	a5,-698(a5) # 8000a46c <panicked>
    8000572e:	efbd                	bnez	a5,800057ac <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005730:	00005717          	auipc	a4,0x5
    80005734:	d4873703          	ld	a4,-696(a4) # 8000a478 <uart_tx_w>
    80005738:	00005797          	auipc	a5,0x5
    8000573c:	d387b783          	ld	a5,-712(a5) # 8000a470 <uart_tx_r>
    80005740:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80005744:	0001e997          	auipc	s3,0x1e
    80005748:	03498993          	addi	s3,s3,52 # 80023778 <uart_tx_lock>
    8000574c:	00005497          	auipc	s1,0x5
    80005750:	d2448493          	addi	s1,s1,-732 # 8000a470 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005754:	00005917          	auipc	s2,0x5
    80005758:	d2490913          	addi	s2,s2,-732 # 8000a478 <uart_tx_w>
    8000575c:	00e79d63          	bne	a5,a4,80005776 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    80005760:	85ce                	mv	a1,s3
    80005762:	8526                	mv	a0,s1
    80005764:	c03fb0ef          	jal	80001366 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005768:	00093703          	ld	a4,0(s2)
    8000576c:	609c                	ld	a5,0(s1)
    8000576e:	02078793          	addi	a5,a5,32
    80005772:	fee787e3          	beq	a5,a4,80005760 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80005776:	0001e497          	auipc	s1,0x1e
    8000577a:	00248493          	addi	s1,s1,2 # 80023778 <uart_tx_lock>
    8000577e:	01f77793          	andi	a5,a4,31
    80005782:	97a6                	add	a5,a5,s1
    80005784:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80005788:	0705                	addi	a4,a4,1
    8000578a:	00005797          	auipc	a5,0x5
    8000578e:	cee7b723          	sd	a4,-786(a5) # 8000a478 <uart_tx_w>
  uartstart();
    80005792:	ed7ff0ef          	jal	80005668 <uartstart>
  release(&uart_tx_lock);
    80005796:	8526                	mv	a0,s1
    80005798:	190000ef          	jal	80005928 <release>
}
    8000579c:	70a2                	ld	ra,40(sp)
    8000579e:	7402                	ld	s0,32(sp)
    800057a0:	64e2                	ld	s1,24(sp)
    800057a2:	6942                	ld	s2,16(sp)
    800057a4:	69a2                	ld	s3,8(sp)
    800057a6:	6a02                	ld	s4,0(sp)
    800057a8:	6145                	addi	sp,sp,48
    800057aa:	8082                	ret
    for(;;)
    800057ac:	a001                	j	800057ac <uartputc+0xa4>

00000000800057ae <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800057ae:	1141                	addi	sp,sp,-16
    800057b0:	e422                	sd	s0,8(sp)
    800057b2:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800057b4:	100007b7          	lui	a5,0x10000
    800057b8:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    800057ba:	0007c783          	lbu	a5,0(a5)
    800057be:	8b85                	andi	a5,a5,1
    800057c0:	cb81                	beqz	a5,800057d0 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    800057c2:	100007b7          	lui	a5,0x10000
    800057c6:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800057ca:	6422                	ld	s0,8(sp)
    800057cc:	0141                	addi	sp,sp,16
    800057ce:	8082                	ret
    return -1;
    800057d0:	557d                	li	a0,-1
    800057d2:	bfe5                	j	800057ca <uartgetc+0x1c>

00000000800057d4 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800057d4:	1101                	addi	sp,sp,-32
    800057d6:	ec06                	sd	ra,24(sp)
    800057d8:	e822                	sd	s0,16(sp)
    800057da:	e426                	sd	s1,8(sp)
    800057dc:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800057de:	54fd                	li	s1,-1
    800057e0:	a019                	j	800057e6 <uartintr+0x12>
      break;
    consoleintr(c);
    800057e2:	85fff0ef          	jal	80005040 <consoleintr>
    int c = uartgetc();
    800057e6:	fc9ff0ef          	jal	800057ae <uartgetc>
    if(c == -1)
    800057ea:	fe951ce3          	bne	a0,s1,800057e2 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800057ee:	0001e497          	auipc	s1,0x1e
    800057f2:	f8a48493          	addi	s1,s1,-118 # 80023778 <uart_tx_lock>
    800057f6:	8526                	mv	a0,s1
    800057f8:	098000ef          	jal	80005890 <acquire>
  uartstart();
    800057fc:	e6dff0ef          	jal	80005668 <uartstart>
  release(&uart_tx_lock);
    80005800:	8526                	mv	a0,s1
    80005802:	126000ef          	jal	80005928 <release>
}
    80005806:	60e2                	ld	ra,24(sp)
    80005808:	6442                	ld	s0,16(sp)
    8000580a:	64a2                	ld	s1,8(sp)
    8000580c:	6105                	addi	sp,sp,32
    8000580e:	8082                	ret

0000000080005810 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80005810:	1141                	addi	sp,sp,-16
    80005812:	e422                	sd	s0,8(sp)
    80005814:	0800                	addi	s0,sp,16
  lk->name = name;
    80005816:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80005818:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000581c:	00053823          	sd	zero,16(a0)
}
    80005820:	6422                	ld	s0,8(sp)
    80005822:	0141                	addi	sp,sp,16
    80005824:	8082                	ret

0000000080005826 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80005826:	411c                	lw	a5,0(a0)
    80005828:	e399                	bnez	a5,8000582e <holding+0x8>
    8000582a:	4501                	li	a0,0
  return r;
}
    8000582c:	8082                	ret
{
    8000582e:	1101                	addi	sp,sp,-32
    80005830:	ec06                	sd	ra,24(sp)
    80005832:	e822                	sd	s0,16(sp)
    80005834:	e426                	sd	s1,8(sp)
    80005836:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80005838:	6904                	ld	s1,16(a0)
    8000583a:	d42fb0ef          	jal	80000d7c <mycpu>
    8000583e:	40a48533          	sub	a0,s1,a0
    80005842:	00153513          	seqz	a0,a0
}
    80005846:	60e2                	ld	ra,24(sp)
    80005848:	6442                	ld	s0,16(sp)
    8000584a:	64a2                	ld	s1,8(sp)
    8000584c:	6105                	addi	sp,sp,32
    8000584e:	8082                	ret

0000000080005850 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80005850:	1101                	addi	sp,sp,-32
    80005852:	ec06                	sd	ra,24(sp)
    80005854:	e822                	sd	s0,16(sp)
    80005856:	e426                	sd	s1,8(sp)
    80005858:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000585a:	100024f3          	csrr	s1,sstatus
    8000585e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80005862:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005864:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80005868:	d14fb0ef          	jal	80000d7c <mycpu>
    8000586c:	5d3c                	lw	a5,120(a0)
    8000586e:	cb99                	beqz	a5,80005884 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80005870:	d0cfb0ef          	jal	80000d7c <mycpu>
    80005874:	5d3c                	lw	a5,120(a0)
    80005876:	2785                	addiw	a5,a5,1
    80005878:	dd3c                	sw	a5,120(a0)
}
    8000587a:	60e2                	ld	ra,24(sp)
    8000587c:	6442                	ld	s0,16(sp)
    8000587e:	64a2                	ld	s1,8(sp)
    80005880:	6105                	addi	sp,sp,32
    80005882:	8082                	ret
    mycpu()->intena = old;
    80005884:	cf8fb0ef          	jal	80000d7c <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80005888:	8085                	srli	s1,s1,0x1
    8000588a:	8885                	andi	s1,s1,1
    8000588c:	dd64                	sw	s1,124(a0)
    8000588e:	b7cd                	j	80005870 <push_off+0x20>

0000000080005890 <acquire>:
{
    80005890:	1101                	addi	sp,sp,-32
    80005892:	ec06                	sd	ra,24(sp)
    80005894:	e822                	sd	s0,16(sp)
    80005896:	e426                	sd	s1,8(sp)
    80005898:	1000                	addi	s0,sp,32
    8000589a:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000589c:	fb5ff0ef          	jal	80005850 <push_off>
  if(holding(lk))
    800058a0:	8526                	mv	a0,s1
    800058a2:	f85ff0ef          	jal	80005826 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800058a6:	4705                	li	a4,1
  if(holding(lk))
    800058a8:	e105                	bnez	a0,800058c8 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800058aa:	87ba                	mv	a5,a4
    800058ac:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800058b0:	2781                	sext.w	a5,a5
    800058b2:	ffe5                	bnez	a5,800058aa <acquire+0x1a>
  __sync_synchronize();
    800058b4:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    800058b8:	cc4fb0ef          	jal	80000d7c <mycpu>
    800058bc:	e888                	sd	a0,16(s1)
}
    800058be:	60e2                	ld	ra,24(sp)
    800058c0:	6442                	ld	s0,16(sp)
    800058c2:	64a2                	ld	s1,8(sp)
    800058c4:	6105                	addi	sp,sp,32
    800058c6:	8082                	ret
    panic("acquire");
    800058c8:	00002517          	auipc	a0,0x2
    800058cc:	f3850513          	addi	a0,a0,-200 # 80007800 <etext+0x800>
    800058d0:	c93ff0ef          	jal	80005562 <panic>

00000000800058d4 <pop_off>:

void
pop_off(void)
{
    800058d4:	1141                	addi	sp,sp,-16
    800058d6:	e406                	sd	ra,8(sp)
    800058d8:	e022                	sd	s0,0(sp)
    800058da:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800058dc:	ca0fb0ef          	jal	80000d7c <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800058e0:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800058e4:	8b89                	andi	a5,a5,2
  if(intr_get())
    800058e6:	e78d                	bnez	a5,80005910 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800058e8:	5d3c                	lw	a5,120(a0)
    800058ea:	02f05963          	blez	a5,8000591c <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    800058ee:	37fd                	addiw	a5,a5,-1
    800058f0:	0007871b          	sext.w	a4,a5
    800058f4:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800058f6:	eb09                	bnez	a4,80005908 <pop_off+0x34>
    800058f8:	5d7c                	lw	a5,124(a0)
    800058fa:	c799                	beqz	a5,80005908 <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800058fc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80005900:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005904:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80005908:	60a2                	ld	ra,8(sp)
    8000590a:	6402                	ld	s0,0(sp)
    8000590c:	0141                	addi	sp,sp,16
    8000590e:	8082                	ret
    panic("pop_off - interruptible");
    80005910:	00002517          	auipc	a0,0x2
    80005914:	ef850513          	addi	a0,a0,-264 # 80007808 <etext+0x808>
    80005918:	c4bff0ef          	jal	80005562 <panic>
    panic("pop_off");
    8000591c:	00002517          	auipc	a0,0x2
    80005920:	f0450513          	addi	a0,a0,-252 # 80007820 <etext+0x820>
    80005924:	c3fff0ef          	jal	80005562 <panic>

0000000080005928 <release>:
{
    80005928:	1101                	addi	sp,sp,-32
    8000592a:	ec06                	sd	ra,24(sp)
    8000592c:	e822                	sd	s0,16(sp)
    8000592e:	e426                	sd	s1,8(sp)
    80005930:	1000                	addi	s0,sp,32
    80005932:	84aa                	mv	s1,a0
  if(!holding(lk))
    80005934:	ef3ff0ef          	jal	80005826 <holding>
    80005938:	c105                	beqz	a0,80005958 <release+0x30>
  lk->cpu = 0;
    8000593a:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000593e:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80005942:	0310000f          	fence	rw,w
    80005946:	0004a023          	sw	zero,0(s1)
  pop_off();
    8000594a:	f8bff0ef          	jal	800058d4 <pop_off>
}
    8000594e:	60e2                	ld	ra,24(sp)
    80005950:	6442                	ld	s0,16(sp)
    80005952:	64a2                	ld	s1,8(sp)
    80005954:	6105                	addi	sp,sp,32
    80005956:	8082                	ret
    panic("release");
    80005958:	00002517          	auipc	a0,0x2
    8000595c:	ed050513          	addi	a0,a0,-304 # 80007828 <etext+0x828>
    80005960:	c03ff0ef          	jal	80005562 <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0)
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	8282                	jr	t0

000000008000609c <userret>:
    8000609c:	12000073          	sfence.vma
    800060a0:	18051073          	csrw	satp,a0
    800060a4:	12000073          	sfence.vma
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800060ae:	0536                	slli	a0,a0,0xd
    800060b0:	02853083          	ld	ra,40(a0)
    800060b4:	03053103          	ld	sp,48(a0)
    800060b8:	03853183          	ld	gp,56(a0)
    800060bc:	04053203          	ld	tp,64(a0)
    800060c0:	04853283          	ld	t0,72(a0)
    800060c4:	05053303          	ld	t1,80(a0)
    800060c8:	05853383          	ld	t2,88(a0)
    800060cc:	7120                	ld	s0,96(a0)
    800060ce:	7524                	ld	s1,104(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
    800060d2:	6150                	ld	a2,128(a0)
    800060d4:	6554                	ld	a3,136(a0)
    800060d6:	6958                	ld	a4,144(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
    800060da:	0a053803          	ld	a6,160(a0)
    800060de:	0a853883          	ld	a7,168(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
    80006112:	11053f03          	ld	t5,272(a0)
    80006116:	11853f83          	ld	t6,280(a0)
    8000611a:	7928                	ld	a0,112(a0)
    8000611c:	10200073          	sret
	...
