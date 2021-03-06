; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.2 | FileCheck %s --check-prefixes=SSE
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s --check-prefixes=AVX12,AVX1
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefixes=AVX12,AVX2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f | FileCheck %s --check-prefix=AVX512 --check-prefix=AVX512F
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f,+avx512bw | FileCheck %s --check-prefix=AVX512 --check-prefix=AVX512BW

define i32 @v32i16(<32 x i16> %a, <32 x i16> %b) {
; SSE-LABEL: v32i16:
; SSE:       # %bb.0:
; SSE-NEXT:    pcmpgtw %xmm5, %xmm1
; SSE-NEXT:    pcmpgtw %xmm4, %xmm0
; SSE-NEXT:    packsswb %xmm1, %xmm0
; SSE-NEXT:    pmovmskb %xmm0, %ecx
; SSE-NEXT:    pcmpgtw %xmm7, %xmm3
; SSE-NEXT:    pcmpgtw %xmm6, %xmm2
; SSE-NEXT:    packsswb %xmm3, %xmm2
; SSE-NEXT:    pmovmskb %xmm2, %eax
; SSE-NEXT:    shll $16, %eax
; SSE-NEXT:    orl %ecx, %eax
; SSE-NEXT:    retq
;
; AVX1-LABEL: v32i16:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vextractf128 $1, %ymm2, %xmm4
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm5
; AVX1-NEXT:    vpcmpgtw %xmm4, %xmm5, %xmm4
; AVX1-NEXT:    vpcmpgtw %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vpacksswb %xmm4, %xmm0, %xmm0
; AVX1-NEXT:    vpmovmskb %xmm0, %ecx
; AVX1-NEXT:    vextractf128 $1, %ymm3, %xmm0
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm2
; AVX1-NEXT:    vpcmpgtw %xmm0, %xmm2, %xmm0
; AVX1-NEXT:    vpcmpgtw %xmm3, %xmm1, %xmm1
; AVX1-NEXT:    vpacksswb %xmm0, %xmm1, %xmm0
; AVX1-NEXT:    vpmovmskb %xmm0, %eax
; AVX1-NEXT:    shll $16, %eax
; AVX1-NEXT:    orl %ecx, %eax
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: v32i16:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpcmpgtw %ymm3, %ymm1, %ymm1
; AVX2-NEXT:    vpcmpgtw %ymm2, %ymm0, %ymm0
; AVX2-NEXT:    vpacksswb %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vpermq {{.*#+}} ymm0 = ymm0[0,2,1,3]
; AVX2-NEXT:    vpmovmskb %ymm0, %eax
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: v32i16:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpcmpgtw %ymm2, %ymm0, %ymm0
; AVX512F-NEXT:    vpmovsxwd %ymm0, %zmm0
; AVX512F-NEXT:    vptestmd %zmm0, %zmm0, %k0
; AVX512F-NEXT:    kmovw %k0, %ecx
; AVX512F-NEXT:    vpcmpgtw %ymm3, %ymm1, %ymm0
; AVX512F-NEXT:    vpmovsxwd %ymm0, %zmm0
; AVX512F-NEXT:    vptestmd %zmm0, %zmm0, %k0
; AVX512F-NEXT:    kmovw %k0, %eax
; AVX512F-NEXT:    shll $16, %eax
; AVX512F-NEXT:    orl %ecx, %eax
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: v32i16:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpcmpgtw %zmm1, %zmm0, %k0
; AVX512BW-NEXT:    kmovd %k0, %eax
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
  %x = icmp sgt <32 x i16> %a, %b
  %res = bitcast <32 x i1> %x to i32
  ret i32 %res
}

define i16 @v16i32(<16 x i32> %a, <16 x i32> %b) {
; SSE-LABEL: v16i32:
; SSE:       # %bb.0:
; SSE-NEXT:    pcmpgtd %xmm7, %xmm3
; SSE-NEXT:    pcmpgtd %xmm6, %xmm2
; SSE-NEXT:    packssdw %xmm3, %xmm2
; SSE-NEXT:    pcmpgtd %xmm5, %xmm1
; SSE-NEXT:    pcmpgtd %xmm4, %xmm0
; SSE-NEXT:    packssdw %xmm1, %xmm0
; SSE-NEXT:    packsswb %xmm2, %xmm0
; SSE-NEXT:    pmovmskb %xmm0, %eax
; SSE-NEXT:    # kill: def %ax killed %ax killed %eax
; SSE-NEXT:    retq
;
; AVX1-LABEL: v16i32:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vextractf128 $1, %ymm3, %xmm4
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm5
; AVX1-NEXT:    vpcmpgtd %xmm4, %xmm5, %xmm4
; AVX1-NEXT:    vpcmpgtd %xmm3, %xmm1, %xmm1
; AVX1-NEXT:    vpackssdw %xmm4, %xmm1, %xmm1
; AVX1-NEXT:    vextractf128 $1, %ymm2, %xmm3
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm4
; AVX1-NEXT:    vpcmpgtd %xmm3, %xmm4, %xmm3
; AVX1-NEXT:    vpcmpgtd %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vpackssdw %xmm3, %xmm0, %xmm0
; AVX1-NEXT:    vpacksswb %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vpmovmskb %xmm0, %eax
; AVX1-NEXT:    # kill: def %ax killed %ax killed %eax
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: v16i32:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpcmpgtd %ymm3, %ymm1, %ymm1
; AVX2-NEXT:    vpcmpgtd %ymm2, %ymm0, %ymm0
; AVX2-NEXT:    vpacksswb %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vpermq {{.*#+}} ymm0 = ymm0[0,2,1,3]
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm1
; AVX2-NEXT:    vpacksswb %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    vpmovmskb %xmm0, %eax
; AVX2-NEXT:    # kill: def %ax killed %ax killed %eax
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: v16i32:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpcmpgtd %zmm1, %zmm0, %k0
; AVX512F-NEXT:    kmovw %k0, %eax
; AVX512F-NEXT:    # kill: def %ax killed %ax killed %eax
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: v16i32:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpcmpgtd %zmm1, %zmm0, %k0
; AVX512BW-NEXT:    kmovd %k0, %eax
; AVX512BW-NEXT:    # kill: def %ax killed %ax killed %eax
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
  %x = icmp sgt <16 x i32> %a, %b
  %res = bitcast <16 x i1> %x to i16
  ret i16 %res
}

define i16 @v16f32(<16 x float> %a, <16 x float> %b) {
; SSE-LABEL: v16f32:
; SSE:       # %bb.0:
; SSE-NEXT:    cmpltps %xmm3, %xmm7
; SSE-NEXT:    cmpltps %xmm2, %xmm6
; SSE-NEXT:    packssdw %xmm7, %xmm6
; SSE-NEXT:    cmpltps %xmm1, %xmm5
; SSE-NEXT:    cmpltps %xmm0, %xmm4
; SSE-NEXT:    packssdw %xmm5, %xmm4
; SSE-NEXT:    packsswb %xmm6, %xmm4
; SSE-NEXT:    pmovmskb %xmm4, %eax
; SSE-NEXT:    # kill: def %ax killed %ax killed %eax
; SSE-NEXT:    retq
;
; AVX1-LABEL: v16f32:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vcmpltps %ymm1, %ymm3, %ymm1
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm3
; AVX1-NEXT:    vpackssdw %xmm3, %xmm1, %xmm1
; AVX1-NEXT:    vcmpltps %ymm0, %ymm2, %ymm0
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm2
; AVX1-NEXT:    vpackssdw %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vpacksswb %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vpmovmskb %xmm0, %eax
; AVX1-NEXT:    # kill: def %ax killed %ax killed %eax
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: v16f32:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vcmpltps %ymm1, %ymm3, %ymm1
; AVX2-NEXT:    vcmpltps %ymm0, %ymm2, %ymm0
; AVX2-NEXT:    vpacksswb %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vpermq {{.*#+}} ymm0 = ymm0[0,2,1,3]
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm1
; AVX2-NEXT:    vpacksswb %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    vpmovmskb %xmm0, %eax
; AVX2-NEXT:    # kill: def %ax killed %ax killed %eax
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: v16f32:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vcmpltps %zmm0, %zmm1, %k0
; AVX512F-NEXT:    kmovw %k0, %eax
; AVX512F-NEXT:    # kill: def %ax killed %ax killed %eax
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: v16f32:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vcmpltps %zmm0, %zmm1, %k0
; AVX512BW-NEXT:    kmovd %k0, %eax
; AVX512BW-NEXT:    # kill: def %ax killed %ax killed %eax
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
  %x = fcmp ogt <16 x float> %a, %b
  %res = bitcast <16 x i1> %x to i16
  ret i16 %res
}

define i64 @v64i8(<64 x i8> %a, <64 x i8> %b) {
; SSE-LABEL: v64i8:
; SSE:       # %bb.0:
; SSE-NEXT:    pcmpgtb %xmm5, %xmm1
; SSE-NEXT:    pextrb $1, %xmm1, %eax
; SSE-NEXT:    andl $1, %eax
; SSE-NEXT:    pextrb $0, %xmm1, %ecx
; SSE-NEXT:    andl $1, %ecx
; SSE-NEXT:    leal (%rcx,%rax,2), %eax
; SSE-NEXT:    pextrb $2, %xmm1, %ecx
; SSE-NEXT:    andl $1, %ecx
; SSE-NEXT:    leal (%rax,%rcx,4), %eax
; SSE-NEXT:    pextrb $3, %xmm1, %ecx
; SSE-NEXT:    andl $1, %ecx
; SSE-NEXT:    leal (%rax,%rcx,8), %eax
; SSE-NEXT:    pextrb $4, %xmm1, %ecx
; SSE-NEXT:    andl $1, %ecx
; SSE-NEXT:    shll $4, %ecx
; SSE-NEXT:    orl %eax, %ecx
; SSE-NEXT:    pextrb $5, %xmm1, %eax
; SSE-NEXT:    andl $1, %eax
; SSE-NEXT:    shll $5, %eax
; SSE-NEXT:    orl %ecx, %eax
; SSE-NEXT:    pextrb $6, %xmm1, %ecx
; SSE-NEXT:    andl $1, %ecx
; SSE-NEXT:    shll $6, %ecx
; SSE-NEXT:    pextrb $7, %xmm1, %edx
; SSE-NEXT:    andl $1, %edx
; SSE-NEXT:    shll $7, %edx
; SSE-NEXT:    orl %ecx, %edx
; SSE-NEXT:    pextrb $8, %xmm1, %ecx
; SSE-NEXT:    andl $1, %ecx
; SSE-NEXT:    shll $8, %ecx
; SSE-NEXT:    orl %edx, %ecx
; SSE-NEXT:    pextrb $9, %xmm1, %edx
; SSE-NEXT:    andl $1, %edx
; SSE-NEXT:    shll $9, %edx
; SSE-NEXT:    orl %ecx, %edx
; SSE-NEXT:    pextrb $10, %xmm1, %ecx
; SSE-NEXT:    andl $1, %ecx
; SSE-NEXT:    shll $10, %ecx
; SSE-NEXT:    orl %edx, %ecx
; SSE-NEXT:    pextrb $11, %xmm1, %edx
; SSE-NEXT:    andl $1, %edx
; SSE-NEXT:    shll $11, %edx
; SSE-NEXT:    orl %ecx, %edx
; SSE-NEXT:    pextrb $12, %xmm1, %ecx
; SSE-NEXT:    andl $1, %ecx
; SSE-NEXT:    shll $12, %ecx
; SSE-NEXT:    orl %edx, %ecx
; SSE-NEXT:    pextrb $13, %xmm1, %edx
; SSE-NEXT:    andl $1, %edx
; SSE-NEXT:    shll $13, %edx
; SSE-NEXT:    orl %ecx, %edx
; SSE-NEXT:    pextrb $14, %xmm1, %ecx
; SSE-NEXT:    andl $1, %ecx
; SSE-NEXT:    shll $14, %ecx
; SSE-NEXT:    orl %edx, %ecx
; SSE-NEXT:    pextrb $15, %xmm1, %edx
; SSE-NEXT:    shll $15, %edx
; SSE-NEXT:    orl %ecx, %edx
; SSE-NEXT:    orl %eax, %edx
; SSE-NEXT:    movw %dx, -{{[0-9]+}}(%rsp)
; SSE-NEXT:    pcmpgtb %xmm4, %xmm0
; SSE-NEXT:    pextrb $1, %xmm0, %eax
; SSE-NEXT:    andl $1, %eax
; SSE-NEXT:    pextrb $0, %xmm0, %ecx
; SSE-NEXT:    andl $1, %ecx
; SSE-NEXT:    leal (%rcx,%rax,2), %eax
; SSE-NEXT:    pextrb $2, %xmm0, %ecx
; SSE-NEXT:    andl $1, %ecx
; SSE-NEXT:    leal (%rax,%rcx,4), %eax
; SSE-NEXT:    pextrb $3, %xmm0, %ecx
; SSE-NEXT:    andl $1, %ecx
; SSE-NEXT:    leal (%rax,%rcx,8), %eax
; SSE-NEXT:    pextrb $4, %xmm0, %ecx
; SSE-NEXT:    andl $1, %ecx
; SSE-NEXT:    shll $4, %ecx
; SSE-NEXT:    orl %eax, %ecx
; SSE-NEXT:    pextrb $5, %xmm0, %eax
; SSE-NEXT:    andl $1, %eax
; SSE-NEXT:    shll $5, %eax
; SSE-NEXT:    orl %ecx, %eax
; SSE-NEXT:    pextrb $6, %xmm0, %ecx
; SSE-NEXT:    andl $1, %ecx
; SSE-NEXT:    shll $6, %ecx
; SSE-NEXT:    pextrb $7, %xmm0, %edx
; SSE-NEXT:    andl $1, %edx
; SSE-NEXT:    shll $7, %edx
; SSE-NEXT:    orl %ecx, %edx
; SSE-NEXT:    pextrb $8, %xmm0, %ecx
; SSE-NEXT:    andl $1, %ecx
; SSE-NEXT:    shll $8, %ecx
; SSE-NEXT:    orl %edx, %ecx
; SSE-NEXT:    pextrb $9, %xmm0, %edx
; SSE-NEXT:    andl $1, %edx
; SSE-NEXT:    shll $9, %edx
; SSE-NEXT:    orl %ecx, %edx
; SSE-NEXT:    pextrb $10, %xmm0, %ecx
; SSE-NEXT:    andl $1, %ecx
; SSE-NEXT:    shll $10, %ecx
; SSE-NEXT:    orl %edx, %ecx
; SSE-NEXT:    pextrb $11, %xmm0, %edx
; SSE-NEXT:    andl $1, %edx
; SSE-NEXT:    shll $11, %edx
; SSE-NEXT:    orl %ecx, %edx
; SSE-NEXT:    pextrb $12, %xmm0, %ecx
; SSE-NEXT:    andl $1, %ecx
; SSE-NEXT:    shll $12, %ecx
; SSE-NEXT:    orl %edx, %ecx
; SSE-NEXT:    pextrb $13, %xmm0, %edx
; SSE-NEXT:    andl $1, %edx
; SSE-NEXT:    shll $13, %edx
; SSE-NEXT:    orl %ecx, %edx
; SSE-NEXT:    pextrb $14, %xmm0, %ecx
; SSE-NEXT:    andl $1, %ecx
; SSE-NEXT:    shll $14, %ecx
; SSE-NEXT:    orl %edx, %ecx
; SSE-NEXT:    pextrb $15, %xmm0, %edx
; SSE-NEXT:    shll $15, %edx
; SSE-NEXT:    orl %ecx, %edx
; SSE-NEXT:    orl %eax, %edx
; SSE-NEXT:    movw %dx, -{{[0-9]+}}(%rsp)
; SSE-NEXT:    pcmpgtb %xmm7, %xmm3
; SSE-NEXT:    pextrb $1, %xmm3, %eax
; SSE-NEXT:    andl $1, %eax
; SSE-NEXT:    pextrb $0, %xmm3, %ecx
; SSE-NEXT:    andl $1, %ecx
; SSE-NEXT:    leal (%rcx,%rax,2), %eax
; SSE-NEXT:    pextrb $2, %xmm3, %ecx
; SSE-NEXT:    andl $1, %ecx
; SSE-NEXT:    leal (%rax,%rcx,4), %eax
; SSE-NEXT:    pextrb $3, %xmm3, %ecx
; SSE-NEXT:    andl $1, %ecx
; SSE-NEXT:    leal (%rax,%rcx,8), %eax
; SSE-NEXT:    pextrb $4, %xmm3, %ecx
; SSE-NEXT:    andl $1, %ecx
; SSE-NEXT:    shll $4, %ecx
; SSE-NEXT:    orl %eax, %ecx
; SSE-NEXT:    pextrb $5, %xmm3, %eax
; SSE-NEXT:    andl $1, %eax
; SSE-NEXT:    shll $5, %eax
; SSE-NEXT:    orl %ecx, %eax
; SSE-NEXT:    pextrb $6, %xmm3, %ecx
; SSE-NEXT:    andl $1, %ecx
; SSE-NEXT:    shll $6, %ecx
; SSE-NEXT:    pextrb $7, %xmm3, %edx
; SSE-NEXT:    andl $1, %edx
; SSE-NEXT:    shll $7, %edx
; SSE-NEXT:    orl %ecx, %edx
; SSE-NEXT:    pextrb $8, %xmm3, %ecx
; SSE-NEXT:    andl $1, %ecx
; SSE-NEXT:    shll $8, %ecx
; SSE-NEXT:    orl %edx, %ecx
; SSE-NEXT:    pextrb $9, %xmm3, %edx
; SSE-NEXT:    andl $1, %edx
; SSE-NEXT:    shll $9, %edx
; SSE-NEXT:    orl %ecx, %edx
; SSE-NEXT:    pextrb $10, %xmm3, %ecx
; SSE-NEXT:    andl $1, %ecx
; SSE-NEXT:    shll $10, %ecx
; SSE-NEXT:    orl %edx, %ecx
; SSE-NEXT:    pextrb $11, %xmm3, %edx
; SSE-NEXT:    andl $1, %edx
; SSE-NEXT:    shll $11, %edx
; SSE-NEXT:    orl %ecx, %edx
; SSE-NEXT:    pextrb $12, %xmm3, %ecx
; SSE-NEXT:    andl $1, %ecx
; SSE-NEXT:    shll $12, %ecx
; SSE-NEXT:    orl %edx, %ecx
; SSE-NEXT:    pextrb $13, %xmm3, %edx
; SSE-NEXT:    andl $1, %edx
; SSE-NEXT:    shll $13, %edx
; SSE-NEXT:    orl %ecx, %edx
; SSE-NEXT:    pextrb $14, %xmm3, %ecx
; SSE-NEXT:    andl $1, %ecx
; SSE-NEXT:    shll $14, %ecx
; SSE-NEXT:    orl %edx, %ecx
; SSE-NEXT:    pextrb $15, %xmm3, %edx
; SSE-NEXT:    shll $15, %edx
; SSE-NEXT:    orl %ecx, %edx
; SSE-NEXT:    orl %eax, %edx
; SSE-NEXT:    movw %dx, -{{[0-9]+}}(%rsp)
; SSE-NEXT:    pcmpgtb %xmm6, %xmm2
; SSE-NEXT:    pextrb $1, %xmm2, %eax
; SSE-NEXT:    andl $1, %eax
; SSE-NEXT:    pextrb $0, %xmm2, %ecx
; SSE-NEXT:    andl $1, %ecx
; SSE-NEXT:    leal (%rcx,%rax,2), %eax
; SSE-NEXT:    pextrb $2, %xmm2, %ecx
; SSE-NEXT:    andl $1, %ecx
; SSE-NEXT:    leal (%rax,%rcx,4), %eax
; SSE-NEXT:    pextrb $3, %xmm2, %ecx
; SSE-NEXT:    andl $1, %ecx
; SSE-NEXT:    leal (%rax,%rcx,8), %eax
; SSE-NEXT:    pextrb $4, %xmm2, %ecx
; SSE-NEXT:    andl $1, %ecx
; SSE-NEXT:    shll $4, %ecx
; SSE-NEXT:    orl %eax, %ecx
; SSE-NEXT:    pextrb $5, %xmm2, %eax
; SSE-NEXT:    andl $1, %eax
; SSE-NEXT:    shll $5, %eax
; SSE-NEXT:    orl %ecx, %eax
; SSE-NEXT:    pextrb $6, %xmm2, %ecx
; SSE-NEXT:    andl $1, %ecx
; SSE-NEXT:    shll $6, %ecx
; SSE-NEXT:    pextrb $7, %xmm2, %edx
; SSE-NEXT:    andl $1, %edx
; SSE-NEXT:    shll $7, %edx
; SSE-NEXT:    orl %ecx, %edx
; SSE-NEXT:    pextrb $8, %xmm2, %ecx
; SSE-NEXT:    andl $1, %ecx
; SSE-NEXT:    shll $8, %ecx
; SSE-NEXT:    orl %edx, %ecx
; SSE-NEXT:    pextrb $9, %xmm2, %edx
; SSE-NEXT:    andl $1, %edx
; SSE-NEXT:    shll $9, %edx
; SSE-NEXT:    orl %ecx, %edx
; SSE-NEXT:    pextrb $10, %xmm2, %ecx
; SSE-NEXT:    andl $1, %ecx
; SSE-NEXT:    shll $10, %ecx
; SSE-NEXT:    orl %edx, %ecx
; SSE-NEXT:    pextrb $11, %xmm2, %edx
; SSE-NEXT:    andl $1, %edx
; SSE-NEXT:    shll $11, %edx
; SSE-NEXT:    orl %ecx, %edx
; SSE-NEXT:    pextrb $12, %xmm2, %ecx
; SSE-NEXT:    andl $1, %ecx
; SSE-NEXT:    shll $12, %ecx
; SSE-NEXT:    orl %edx, %ecx
; SSE-NEXT:    pextrb $13, %xmm2, %edx
; SSE-NEXT:    andl $1, %edx
; SSE-NEXT:    shll $13, %edx
; SSE-NEXT:    orl %ecx, %edx
; SSE-NEXT:    pextrb $14, %xmm2, %ecx
; SSE-NEXT:    andl $1, %ecx
; SSE-NEXT:    shll $14, %ecx
; SSE-NEXT:    orl %edx, %ecx
; SSE-NEXT:    pextrb $15, %xmm2, %edx
; SSE-NEXT:    shll $15, %edx
; SSE-NEXT:    orl %ecx, %edx
; SSE-NEXT:    orl %eax, %edx
; SSE-NEXT:    movw %dx, -{{[0-9]+}}(%rsp)
; SSE-NEXT:    movl -{{[0-9]+}}(%rsp), %eax
; SSE-NEXT:    shll $16, %eax
; SSE-NEXT:    movzwl -{{[0-9]+}}(%rsp), %ecx
; SSE-NEXT:    orl %eax, %ecx
; SSE-NEXT:    movl -{{[0-9]+}}(%rsp), %edx
; SSE-NEXT:    shll $16, %edx
; SSE-NEXT:    movzwl -{{[0-9]+}}(%rsp), %eax
; SSE-NEXT:    orl %edx, %eax
; SSE-NEXT:    shlq $32, %rax
; SSE-NEXT:    orq %rcx, %rax
; SSE-NEXT:    retq
;
; AVX1-LABEL: v64i8:
; AVX1:       # %bb.0:
; AVX1-NEXT:    pushq %rbp
; AVX1-NEXT:    .cfi_def_cfa_offset 16
; AVX1-NEXT:    .cfi_offset %rbp, -16
; AVX1-NEXT:    movq %rsp, %rbp
; AVX1-NEXT:    .cfi_def_cfa_register %rbp
; AVX1-NEXT:    andq $-32, %rsp
; AVX1-NEXT:    subq $64, %rsp
; AVX1-NEXT:    vpcmpgtb %xmm2, %xmm0, %xmm4
; AVX1-NEXT:    vpextrb $1, %xmm4, %eax
; AVX1-NEXT:    andl $1, %eax
; AVX1-NEXT:    vpextrb $0, %xmm4, %ecx
; AVX1-NEXT:    andl $1, %ecx
; AVX1-NEXT:    leal (%rcx,%rax,2), %eax
; AVX1-NEXT:    vpextrb $2, %xmm4, %ecx
; AVX1-NEXT:    andl $1, %ecx
; AVX1-NEXT:    leal (%rax,%rcx,4), %eax
; AVX1-NEXT:    vpextrb $3, %xmm4, %ecx
; AVX1-NEXT:    andl $1, %ecx
; AVX1-NEXT:    leal (%rax,%rcx,8), %eax
; AVX1-NEXT:    vpextrb $4, %xmm4, %ecx
; AVX1-NEXT:    andl $1, %ecx
; AVX1-NEXT:    shll $4, %ecx
; AVX1-NEXT:    orl %eax, %ecx
; AVX1-NEXT:    vpextrb $5, %xmm4, %eax
; AVX1-NEXT:    andl $1, %eax
; AVX1-NEXT:    shll $5, %eax
; AVX1-NEXT:    orl %ecx, %eax
; AVX1-NEXT:    vpextrb $6, %xmm4, %ecx
; AVX1-NEXT:    andl $1, %ecx
; AVX1-NEXT:    shll $6, %ecx
; AVX1-NEXT:    vpextrb $7, %xmm4, %edx
; AVX1-NEXT:    andl $1, %edx
; AVX1-NEXT:    shll $7, %edx
; AVX1-NEXT:    orl %ecx, %edx
; AVX1-NEXT:    vpextrb $8, %xmm4, %ecx
; AVX1-NEXT:    andl $1, %ecx
; AVX1-NEXT:    shll $8, %ecx
; AVX1-NEXT:    orl %edx, %ecx
; AVX1-NEXT:    vpextrb $9, %xmm4, %edx
; AVX1-NEXT:    andl $1, %edx
; AVX1-NEXT:    shll $9, %edx
; AVX1-NEXT:    orl %ecx, %edx
; AVX1-NEXT:    vpextrb $10, %xmm4, %ecx
; AVX1-NEXT:    andl $1, %ecx
; AVX1-NEXT:    shll $10, %ecx
; AVX1-NEXT:    orl %edx, %ecx
; AVX1-NEXT:    vpextrb $11, %xmm4, %edx
; AVX1-NEXT:    andl $1, %edx
; AVX1-NEXT:    shll $11, %edx
; AVX1-NEXT:    orl %ecx, %edx
; AVX1-NEXT:    vpextrb $12, %xmm4, %ecx
; AVX1-NEXT:    andl $1, %ecx
; AVX1-NEXT:    shll $12, %ecx
; AVX1-NEXT:    orl %edx, %ecx
; AVX1-NEXT:    vpextrb $13, %xmm4, %edx
; AVX1-NEXT:    andl $1, %edx
; AVX1-NEXT:    shll $13, %edx
; AVX1-NEXT:    orl %ecx, %edx
; AVX1-NEXT:    vpextrb $14, %xmm4, %ecx
; AVX1-NEXT:    andl $1, %ecx
; AVX1-NEXT:    shll $14, %ecx
; AVX1-NEXT:    orl %edx, %ecx
; AVX1-NEXT:    vpextrb $15, %xmm4, %edx
; AVX1-NEXT:    andl $1, %edx
; AVX1-NEXT:    shll $15, %edx
; AVX1-NEXT:    orl %ecx, %edx
; AVX1-NEXT:    vextractf128 $1, %ymm2, %xmm2
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm0
; AVX1-NEXT:    vpcmpgtb %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vpextrb $0, %xmm0, %ecx
; AVX1-NEXT:    andl $1, %ecx
; AVX1-NEXT:    shll $16, %ecx
; AVX1-NEXT:    orl %edx, %ecx
; AVX1-NEXT:    vpextrb $1, %xmm0, %edx
; AVX1-NEXT:    andl $1, %edx
; AVX1-NEXT:    shll $17, %edx
; AVX1-NEXT:    orl %ecx, %edx
; AVX1-NEXT:    vpextrb $2, %xmm0, %ecx
; AVX1-NEXT:    andl $1, %ecx
; AVX1-NEXT:    shll $18, %ecx
; AVX1-NEXT:    orl %edx, %ecx
; AVX1-NEXT:    vpextrb $3, %xmm0, %edx
; AVX1-NEXT:    andl $1, %edx
; AVX1-NEXT:    shll $19, %edx
; AVX1-NEXT:    orl %ecx, %edx
; AVX1-NEXT:    vpextrb $4, %xmm0, %ecx
; AVX1-NEXT:    andl $1, %ecx
; AVX1-NEXT:    shll $20, %ecx
; AVX1-NEXT:    orl %edx, %ecx
; AVX1-NEXT:    vpextrb $5, %xmm0, %edx
; AVX1-NEXT:    andl $1, %edx
; AVX1-NEXT:    shll $21, %edx
; AVX1-NEXT:    orl %ecx, %edx
; AVX1-NEXT:    vpextrb $6, %xmm0, %ecx
; AVX1-NEXT:    andl $1, %ecx
; AVX1-NEXT:    shll $22, %ecx
; AVX1-NEXT:    orl %edx, %ecx
; AVX1-NEXT:    vpextrb $7, %xmm0, %edx
; AVX1-NEXT:    andl $1, %edx
; AVX1-NEXT:    shll $23, %edx
; AVX1-NEXT:    orl %ecx, %edx
; AVX1-NEXT:    vpextrb $8, %xmm0, %ecx
; AVX1-NEXT:    andl $1, %ecx
; AVX1-NEXT:    shll $24, %ecx
; AVX1-NEXT:    orl %edx, %ecx
; AVX1-NEXT:    vpextrb $9, %xmm0, %edx
; AVX1-NEXT:    andl $1, %edx
; AVX1-NEXT:    shll $25, %edx
; AVX1-NEXT:    orl %ecx, %edx
; AVX1-NEXT:    vpextrb $10, %xmm0, %ecx
; AVX1-NEXT:    andl $1, %ecx
; AVX1-NEXT:    shll $26, %ecx
; AVX1-NEXT:    orl %edx, %ecx
; AVX1-NEXT:    vpextrb $11, %xmm0, %edx
; AVX1-NEXT:    andl $1, %edx
; AVX1-NEXT:    shll $27, %edx
; AVX1-NEXT:    orl %ecx, %edx
; AVX1-NEXT:    vpextrb $12, %xmm0, %ecx
; AVX1-NEXT:    andl $1, %ecx
; AVX1-NEXT:    shll $28, %ecx
; AVX1-NEXT:    orl %edx, %ecx
; AVX1-NEXT:    vpextrb $13, %xmm0, %edx
; AVX1-NEXT:    andl $1, %edx
; AVX1-NEXT:    shll $29, %edx
; AVX1-NEXT:    orl %ecx, %edx
; AVX1-NEXT:    vpextrb $14, %xmm0, %ecx
; AVX1-NEXT:    andl $1, %ecx
; AVX1-NEXT:    shll $30, %ecx
; AVX1-NEXT:    orl %edx, %ecx
; AVX1-NEXT:    vpextrb $15, %xmm0, %edx
; AVX1-NEXT:    shll $31, %edx
; AVX1-NEXT:    orl %ecx, %edx
; AVX1-NEXT:    orl %eax, %edx
; AVX1-NEXT:    movl %edx, (%rsp)
; AVX1-NEXT:    vpcmpgtb %xmm3, %xmm1, %xmm0
; AVX1-NEXT:    vpextrb $1, %xmm0, %eax
; AVX1-NEXT:    andl $1, %eax
; AVX1-NEXT:    vpextrb $0, %xmm0, %ecx
; AVX1-NEXT:    andl $1, %ecx
; AVX1-NEXT:    leal (%rcx,%rax,2), %eax
; AVX1-NEXT:    vpextrb $2, %xmm0, %ecx
; AVX1-NEXT:    andl $1, %ecx
; AVX1-NEXT:    leal (%rax,%rcx,4), %eax
; AVX1-NEXT:    vpextrb $3, %xmm0, %ecx
; AVX1-NEXT:    andl $1, %ecx
; AVX1-NEXT:    leal (%rax,%rcx,8), %eax
; AVX1-NEXT:    vpextrb $4, %xmm0, %ecx
; AVX1-NEXT:    andl $1, %ecx
; AVX1-NEXT:    shll $4, %ecx
; AVX1-NEXT:    orl %eax, %ecx
; AVX1-NEXT:    vpextrb $5, %xmm0, %eax
; AVX1-NEXT:    andl $1, %eax
; AVX1-NEXT:    shll $5, %eax
; AVX1-NEXT:    orl %ecx, %eax
; AVX1-NEXT:    vpextrb $6, %xmm0, %ecx
; AVX1-NEXT:    andl $1, %ecx
; AVX1-NEXT:    shll $6, %ecx
; AVX1-NEXT:    vpextrb $7, %xmm0, %edx
; AVX1-NEXT:    andl $1, %edx
; AVX1-NEXT:    shll $7, %edx
; AVX1-NEXT:    orl %ecx, %edx
; AVX1-NEXT:    vpextrb $8, %xmm0, %ecx
; AVX1-NEXT:    andl $1, %ecx
; AVX1-NEXT:    shll $8, %ecx
; AVX1-NEXT:    orl %edx, %ecx
; AVX1-NEXT:    vpextrb $9, %xmm0, %edx
; AVX1-NEXT:    andl $1, %edx
; AVX1-NEXT:    shll $9, %edx
; AVX1-NEXT:    orl %ecx, %edx
; AVX1-NEXT:    vpextrb $10, %xmm0, %ecx
; AVX1-NEXT:    andl $1, %ecx
; AVX1-NEXT:    shll $10, %ecx
; AVX1-NEXT:    orl %edx, %ecx
; AVX1-NEXT:    vpextrb $11, %xmm0, %edx
; AVX1-NEXT:    andl $1, %edx
; AVX1-NEXT:    shll $11, %edx
; AVX1-NEXT:    orl %ecx, %edx
; AVX1-NEXT:    vpextrb $12, %xmm0, %ecx
; AVX1-NEXT:    andl $1, %ecx
; AVX1-NEXT:    shll $12, %ecx
; AVX1-NEXT:    orl %edx, %ecx
; AVX1-NEXT:    vpextrb $13, %xmm0, %edx
; AVX1-NEXT:    andl $1, %edx
; AVX1-NEXT:    shll $13, %edx
; AVX1-NEXT:    orl %ecx, %edx
; AVX1-NEXT:    vpextrb $14, %xmm0, %ecx
; AVX1-NEXT:    andl $1, %ecx
; AVX1-NEXT:    shll $14, %ecx
; AVX1-NEXT:    orl %edx, %ecx
; AVX1-NEXT:    vpextrb $15, %xmm0, %edx
; AVX1-NEXT:    andl $1, %edx
; AVX1-NEXT:    shll $15, %edx
; AVX1-NEXT:    orl %ecx, %edx
; AVX1-NEXT:    vextractf128 $1, %ymm3, %xmm0
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm1
; AVX1-NEXT:    vpcmpgtb %xmm0, %xmm1, %xmm0
; AVX1-NEXT:    vpextrb $0, %xmm0, %ecx
; AVX1-NEXT:    andl $1, %ecx
; AVX1-NEXT:    shll $16, %ecx
; AVX1-NEXT:    orl %edx, %ecx
; AVX1-NEXT:    vpextrb $1, %xmm0, %edx
; AVX1-NEXT:    andl $1, %edx
; AVX1-NEXT:    shll $17, %edx
; AVX1-NEXT:    orl %ecx, %edx
; AVX1-NEXT:    vpextrb $2, %xmm0, %ecx
; AVX1-NEXT:    andl $1, %ecx
; AVX1-NEXT:    shll $18, %ecx
; AVX1-NEXT:    orl %edx, %ecx
; AVX1-NEXT:    vpextrb $3, %xmm0, %edx
; AVX1-NEXT:    andl $1, %edx
; AVX1-NEXT:    shll $19, %edx
; AVX1-NEXT:    orl %ecx, %edx
; AVX1-NEXT:    vpextrb $4, %xmm0, %ecx
; AVX1-NEXT:    andl $1, %ecx
; AVX1-NEXT:    shll $20, %ecx
; AVX1-NEXT:    orl %edx, %ecx
; AVX1-NEXT:    vpextrb $5, %xmm0, %edx
; AVX1-NEXT:    andl $1, %edx
; AVX1-NEXT:    shll $21, %edx
; AVX1-NEXT:    orl %ecx, %edx
; AVX1-NEXT:    vpextrb $6, %xmm0, %ecx
; AVX1-NEXT:    andl $1, %ecx
; AVX1-NEXT:    shll $22, %ecx
; AVX1-NEXT:    orl %edx, %ecx
; AVX1-NEXT:    vpextrb $7, %xmm0, %edx
; AVX1-NEXT:    andl $1, %edx
; AVX1-NEXT:    shll $23, %edx
; AVX1-NEXT:    orl %ecx, %edx
; AVX1-NEXT:    vpextrb $8, %xmm0, %ecx
; AVX1-NEXT:    andl $1, %ecx
; AVX1-NEXT:    shll $24, %ecx
; AVX1-NEXT:    orl %edx, %ecx
; AVX1-NEXT:    vpextrb $9, %xmm0, %edx
; AVX1-NEXT:    andl $1, %edx
; AVX1-NEXT:    shll $25, %edx
; AVX1-NEXT:    orl %ecx, %edx
; AVX1-NEXT:    vpextrb $10, %xmm0, %ecx
; AVX1-NEXT:    andl $1, %ecx
; AVX1-NEXT:    shll $26, %ecx
; AVX1-NEXT:    orl %edx, %ecx
; AVX1-NEXT:    vpextrb $11, %xmm0, %edx
; AVX1-NEXT:    andl $1, %edx
; AVX1-NEXT:    shll $27, %edx
; AVX1-NEXT:    orl %ecx, %edx
; AVX1-NEXT:    vpextrb $12, %xmm0, %ecx
; AVX1-NEXT:    andl $1, %ecx
; AVX1-NEXT:    shll $28, %ecx
; AVX1-NEXT:    orl %edx, %ecx
; AVX1-NEXT:    vpextrb $13, %xmm0, %edx
; AVX1-NEXT:    andl $1, %edx
; AVX1-NEXT:    shll $29, %edx
; AVX1-NEXT:    orl %ecx, %edx
; AVX1-NEXT:    vpextrb $14, %xmm0, %ecx
; AVX1-NEXT:    andl $1, %ecx
; AVX1-NEXT:    shll $30, %ecx
; AVX1-NEXT:    orl %edx, %ecx
; AVX1-NEXT:    vpextrb $15, %xmm0, %edx
; AVX1-NEXT:    shll $31, %edx
; AVX1-NEXT:    orl %ecx, %edx
; AVX1-NEXT:    orl %eax, %edx
; AVX1-NEXT:    movl %edx, {{[0-9]+}}(%rsp)
; AVX1-NEXT:    movl (%rsp), %ecx
; AVX1-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; AVX1-NEXT:    shlq $32, %rax
; AVX1-NEXT:    orq %rcx, %rax
; AVX1-NEXT:    movq %rbp, %rsp
; AVX1-NEXT:    popq %rbp
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: v64i8:
; AVX2:       # %bb.0:
; AVX2-NEXT:    pushq %rbp
; AVX2-NEXT:    .cfi_def_cfa_offset 16
; AVX2-NEXT:    .cfi_offset %rbp, -16
; AVX2-NEXT:    movq %rsp, %rbp
; AVX2-NEXT:    .cfi_def_cfa_register %rbp
; AVX2-NEXT:    andq $-32, %rsp
; AVX2-NEXT:    subq $64, %rsp
; AVX2-NEXT:    vpcmpgtb %ymm2, %ymm0, %ymm0
; AVX2-NEXT:    vpextrb $1, %xmm0, %eax
; AVX2-NEXT:    andl $1, %eax
; AVX2-NEXT:    vpextrb $0, %xmm0, %ecx
; AVX2-NEXT:    andl $1, %ecx
; AVX2-NEXT:    leal (%rcx,%rax,2), %eax
; AVX2-NEXT:    vpextrb $2, %xmm0, %ecx
; AVX2-NEXT:    andl $1, %ecx
; AVX2-NEXT:    leal (%rax,%rcx,4), %eax
; AVX2-NEXT:    vpextrb $3, %xmm0, %ecx
; AVX2-NEXT:    andl $1, %ecx
; AVX2-NEXT:    leal (%rax,%rcx,8), %eax
; AVX2-NEXT:    vpextrb $4, %xmm0, %ecx
; AVX2-NEXT:    andl $1, %ecx
; AVX2-NEXT:    shll $4, %ecx
; AVX2-NEXT:    orl %eax, %ecx
; AVX2-NEXT:    vpextrb $5, %xmm0, %eax
; AVX2-NEXT:    andl $1, %eax
; AVX2-NEXT:    shll $5, %eax
; AVX2-NEXT:    orl %ecx, %eax
; AVX2-NEXT:    vpextrb $6, %xmm0, %ecx
; AVX2-NEXT:    andl $1, %ecx
; AVX2-NEXT:    shll $6, %ecx
; AVX2-NEXT:    vpextrb $7, %xmm0, %edx
; AVX2-NEXT:    andl $1, %edx
; AVX2-NEXT:    shll $7, %edx
; AVX2-NEXT:    orl %ecx, %edx
; AVX2-NEXT:    vpextrb $8, %xmm0, %ecx
; AVX2-NEXT:    andl $1, %ecx
; AVX2-NEXT:    shll $8, %ecx
; AVX2-NEXT:    orl %edx, %ecx
; AVX2-NEXT:    vpextrb $9, %xmm0, %edx
; AVX2-NEXT:    andl $1, %edx
; AVX2-NEXT:    shll $9, %edx
; AVX2-NEXT:    orl %ecx, %edx
; AVX2-NEXT:    vpextrb $10, %xmm0, %ecx
; AVX2-NEXT:    andl $1, %ecx
; AVX2-NEXT:    shll $10, %ecx
; AVX2-NEXT:    orl %edx, %ecx
; AVX2-NEXT:    vpextrb $11, %xmm0, %edx
; AVX2-NEXT:    andl $1, %edx
; AVX2-NEXT:    shll $11, %edx
; AVX2-NEXT:    orl %ecx, %edx
; AVX2-NEXT:    vpextrb $12, %xmm0, %ecx
; AVX2-NEXT:    andl $1, %ecx
; AVX2-NEXT:    shll $12, %ecx
; AVX2-NEXT:    orl %edx, %ecx
; AVX2-NEXT:    vpextrb $13, %xmm0, %edx
; AVX2-NEXT:    andl $1, %edx
; AVX2-NEXT:    shll $13, %edx
; AVX2-NEXT:    orl %ecx, %edx
; AVX2-NEXT:    vpextrb $14, %xmm0, %ecx
; AVX2-NEXT:    andl $1, %ecx
; AVX2-NEXT:    shll $14, %ecx
; AVX2-NEXT:    orl %edx, %ecx
; AVX2-NEXT:    vpextrb $15, %xmm0, %edx
; AVX2-NEXT:    andl $1, %edx
; AVX2-NEXT:    shll $15, %edx
; AVX2-NEXT:    orl %ecx, %edx
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm0
; AVX2-NEXT:    vpextrb $0, %xmm0, %ecx
; AVX2-NEXT:    andl $1, %ecx
; AVX2-NEXT:    shll $16, %ecx
; AVX2-NEXT:    orl %edx, %ecx
; AVX2-NEXT:    vpextrb $1, %xmm0, %edx
; AVX2-NEXT:    andl $1, %edx
; AVX2-NEXT:    shll $17, %edx
; AVX2-NEXT:    orl %ecx, %edx
; AVX2-NEXT:    vpextrb $2, %xmm0, %ecx
; AVX2-NEXT:    andl $1, %ecx
; AVX2-NEXT:    shll $18, %ecx
; AVX2-NEXT:    orl %edx, %ecx
; AVX2-NEXT:    vpextrb $3, %xmm0, %edx
; AVX2-NEXT:    andl $1, %edx
; AVX2-NEXT:    shll $19, %edx
; AVX2-NEXT:    orl %ecx, %edx
; AVX2-NEXT:    vpextrb $4, %xmm0, %ecx
; AVX2-NEXT:    andl $1, %ecx
; AVX2-NEXT:    shll $20, %ecx
; AVX2-NEXT:    orl %edx, %ecx
; AVX2-NEXT:    vpextrb $5, %xmm0, %edx
; AVX2-NEXT:    andl $1, %edx
; AVX2-NEXT:    shll $21, %edx
; AVX2-NEXT:    orl %ecx, %edx
; AVX2-NEXT:    vpextrb $6, %xmm0, %ecx
; AVX2-NEXT:    andl $1, %ecx
; AVX2-NEXT:    shll $22, %ecx
; AVX2-NEXT:    orl %edx, %ecx
; AVX2-NEXT:    vpextrb $7, %xmm0, %edx
; AVX2-NEXT:    andl $1, %edx
; AVX2-NEXT:    shll $23, %edx
; AVX2-NEXT:    orl %ecx, %edx
; AVX2-NEXT:    vpextrb $8, %xmm0, %ecx
; AVX2-NEXT:    andl $1, %ecx
; AVX2-NEXT:    shll $24, %ecx
; AVX2-NEXT:    orl %edx, %ecx
; AVX2-NEXT:    vpextrb $9, %xmm0, %edx
; AVX2-NEXT:    andl $1, %edx
; AVX2-NEXT:    shll $25, %edx
; AVX2-NEXT:    orl %ecx, %edx
; AVX2-NEXT:    vpextrb $10, %xmm0, %ecx
; AVX2-NEXT:    andl $1, %ecx
; AVX2-NEXT:    shll $26, %ecx
; AVX2-NEXT:    orl %edx, %ecx
; AVX2-NEXT:    vpextrb $11, %xmm0, %edx
; AVX2-NEXT:    andl $1, %edx
; AVX2-NEXT:    shll $27, %edx
; AVX2-NEXT:    orl %ecx, %edx
; AVX2-NEXT:    vpextrb $12, %xmm0, %ecx
; AVX2-NEXT:    andl $1, %ecx
; AVX2-NEXT:    shll $28, %ecx
; AVX2-NEXT:    orl %edx, %ecx
; AVX2-NEXT:    vpextrb $13, %xmm0, %edx
; AVX2-NEXT:    andl $1, %edx
; AVX2-NEXT:    shll $29, %edx
; AVX2-NEXT:    orl %ecx, %edx
; AVX2-NEXT:    vpextrb $14, %xmm0, %ecx
; AVX2-NEXT:    andl $1, %ecx
; AVX2-NEXT:    shll $30, %ecx
; AVX2-NEXT:    orl %edx, %ecx
; AVX2-NEXT:    vpextrb $15, %xmm0, %edx
; AVX2-NEXT:    shll $31, %edx
; AVX2-NEXT:    orl %ecx, %edx
; AVX2-NEXT:    orl %eax, %edx
; AVX2-NEXT:    movl %edx, (%rsp)
; AVX2-NEXT:    vpcmpgtb %ymm3, %ymm1, %ymm0
; AVX2-NEXT:    vpextrb $1, %xmm0, %eax
; AVX2-NEXT:    andl $1, %eax
; AVX2-NEXT:    vpextrb $0, %xmm0, %ecx
; AVX2-NEXT:    andl $1, %ecx
; AVX2-NEXT:    leal (%rcx,%rax,2), %eax
; AVX2-NEXT:    vpextrb $2, %xmm0, %ecx
; AVX2-NEXT:    andl $1, %ecx
; AVX2-NEXT:    leal (%rax,%rcx,4), %eax
; AVX2-NEXT:    vpextrb $3, %xmm0, %ecx
; AVX2-NEXT:    andl $1, %ecx
; AVX2-NEXT:    leal (%rax,%rcx,8), %eax
; AVX2-NEXT:    vpextrb $4, %xmm0, %ecx
; AVX2-NEXT:    andl $1, %ecx
; AVX2-NEXT:    shll $4, %ecx
; AVX2-NEXT:    orl %eax, %ecx
; AVX2-NEXT:    vpextrb $5, %xmm0, %eax
; AVX2-NEXT:    andl $1, %eax
; AVX2-NEXT:    shll $5, %eax
; AVX2-NEXT:    orl %ecx, %eax
; AVX2-NEXT:    vpextrb $6, %xmm0, %ecx
; AVX2-NEXT:    andl $1, %ecx
; AVX2-NEXT:    shll $6, %ecx
; AVX2-NEXT:    vpextrb $7, %xmm0, %edx
; AVX2-NEXT:    andl $1, %edx
; AVX2-NEXT:    shll $7, %edx
; AVX2-NEXT:    orl %ecx, %edx
; AVX2-NEXT:    vpextrb $8, %xmm0, %ecx
; AVX2-NEXT:    andl $1, %ecx
; AVX2-NEXT:    shll $8, %ecx
; AVX2-NEXT:    orl %edx, %ecx
; AVX2-NEXT:    vpextrb $9, %xmm0, %edx
; AVX2-NEXT:    andl $1, %edx
; AVX2-NEXT:    shll $9, %edx
; AVX2-NEXT:    orl %ecx, %edx
; AVX2-NEXT:    vpextrb $10, %xmm0, %ecx
; AVX2-NEXT:    andl $1, %ecx
; AVX2-NEXT:    shll $10, %ecx
; AVX2-NEXT:    orl %edx, %ecx
; AVX2-NEXT:    vpextrb $11, %xmm0, %edx
; AVX2-NEXT:    andl $1, %edx
; AVX2-NEXT:    shll $11, %edx
; AVX2-NEXT:    orl %ecx, %edx
; AVX2-NEXT:    vpextrb $12, %xmm0, %ecx
; AVX2-NEXT:    andl $1, %ecx
; AVX2-NEXT:    shll $12, %ecx
; AVX2-NEXT:    orl %edx, %ecx
; AVX2-NEXT:    vpextrb $13, %xmm0, %edx
; AVX2-NEXT:    andl $1, %edx
; AVX2-NEXT:    shll $13, %edx
; AVX2-NEXT:    orl %ecx, %edx
; AVX2-NEXT:    vpextrb $14, %xmm0, %ecx
; AVX2-NEXT:    andl $1, %ecx
; AVX2-NEXT:    shll $14, %ecx
; AVX2-NEXT:    orl %edx, %ecx
; AVX2-NEXT:    vpextrb $15, %xmm0, %edx
; AVX2-NEXT:    andl $1, %edx
; AVX2-NEXT:    shll $15, %edx
; AVX2-NEXT:    orl %ecx, %edx
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm0
; AVX2-NEXT:    vpextrb $0, %xmm0, %ecx
; AVX2-NEXT:    andl $1, %ecx
; AVX2-NEXT:    shll $16, %ecx
; AVX2-NEXT:    orl %edx, %ecx
; AVX2-NEXT:    vpextrb $1, %xmm0, %edx
; AVX2-NEXT:    andl $1, %edx
; AVX2-NEXT:    shll $17, %edx
; AVX2-NEXT:    orl %ecx, %edx
; AVX2-NEXT:    vpextrb $2, %xmm0, %ecx
; AVX2-NEXT:    andl $1, %ecx
; AVX2-NEXT:    shll $18, %ecx
; AVX2-NEXT:    orl %edx, %ecx
; AVX2-NEXT:    vpextrb $3, %xmm0, %edx
; AVX2-NEXT:    andl $1, %edx
; AVX2-NEXT:    shll $19, %edx
; AVX2-NEXT:    orl %ecx, %edx
; AVX2-NEXT:    vpextrb $4, %xmm0, %ecx
; AVX2-NEXT:    andl $1, %ecx
; AVX2-NEXT:    shll $20, %ecx
; AVX2-NEXT:    orl %edx, %ecx
; AVX2-NEXT:    vpextrb $5, %xmm0, %edx
; AVX2-NEXT:    andl $1, %edx
; AVX2-NEXT:    shll $21, %edx
; AVX2-NEXT:    orl %ecx, %edx
; AVX2-NEXT:    vpextrb $6, %xmm0, %ecx
; AVX2-NEXT:    andl $1, %ecx
; AVX2-NEXT:    shll $22, %ecx
; AVX2-NEXT:    orl %edx, %ecx
; AVX2-NEXT:    vpextrb $7, %xmm0, %edx
; AVX2-NEXT:    andl $1, %edx
; AVX2-NEXT:    shll $23, %edx
; AVX2-NEXT:    orl %ecx, %edx
; AVX2-NEXT:    vpextrb $8, %xmm0, %ecx
; AVX2-NEXT:    andl $1, %ecx
; AVX2-NEXT:    shll $24, %ecx
; AVX2-NEXT:    orl %edx, %ecx
; AVX2-NEXT:    vpextrb $9, %xmm0, %edx
; AVX2-NEXT:    andl $1, %edx
; AVX2-NEXT:    shll $25, %edx
; AVX2-NEXT:    orl %ecx, %edx
; AVX2-NEXT:    vpextrb $10, %xmm0, %ecx
; AVX2-NEXT:    andl $1, %ecx
; AVX2-NEXT:    shll $26, %ecx
; AVX2-NEXT:    orl %edx, %ecx
; AVX2-NEXT:    vpextrb $11, %xmm0, %edx
; AVX2-NEXT:    andl $1, %edx
; AVX2-NEXT:    shll $27, %edx
; AVX2-NEXT:    orl %ecx, %edx
; AVX2-NEXT:    vpextrb $12, %xmm0, %ecx
; AVX2-NEXT:    andl $1, %ecx
; AVX2-NEXT:    shll $28, %ecx
; AVX2-NEXT:    orl %edx, %ecx
; AVX2-NEXT:    vpextrb $13, %xmm0, %edx
; AVX2-NEXT:    andl $1, %edx
; AVX2-NEXT:    shll $29, %edx
; AVX2-NEXT:    orl %ecx, %edx
; AVX2-NEXT:    vpextrb $14, %xmm0, %ecx
; AVX2-NEXT:    andl $1, %ecx
; AVX2-NEXT:    shll $30, %ecx
; AVX2-NEXT:    orl %edx, %ecx
; AVX2-NEXT:    vpextrb $15, %xmm0, %edx
; AVX2-NEXT:    shll $31, %edx
; AVX2-NEXT:    orl %ecx, %edx
; AVX2-NEXT:    orl %eax, %edx
; AVX2-NEXT:    movl %edx, {{[0-9]+}}(%rsp)
; AVX2-NEXT:    movl (%rsp), %ecx
; AVX2-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; AVX2-NEXT:    shlq $32, %rax
; AVX2-NEXT:    orq %rcx, %rax
; AVX2-NEXT:    movq %rbp, %rsp
; AVX2-NEXT:    popq %rbp
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: v64i8:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpcmpgtb %ymm2, %ymm0, %ymm0
; AVX512F-NEXT:    vpmovsxbd %xmm0, %zmm2
; AVX512F-NEXT:    vptestmd %zmm2, %zmm2, %k0
; AVX512F-NEXT:    kmovw %k0, %eax
; AVX512F-NEXT:    vextracti128 $1, %ymm0, %xmm0
; AVX512F-NEXT:    vpmovsxbd %xmm0, %zmm0
; AVX512F-NEXT:    vptestmd %zmm0, %zmm0, %k0
; AVX512F-NEXT:    kmovw %k0, %ecx
; AVX512F-NEXT:    shll $16, %ecx
; AVX512F-NEXT:    orl %eax, %ecx
; AVX512F-NEXT:    vpcmpgtb %ymm3, %ymm1, %ymm0
; AVX512F-NEXT:    vpmovsxbd %xmm0, %zmm1
; AVX512F-NEXT:    vptestmd %zmm1, %zmm1, %k0
; AVX512F-NEXT:    kmovw %k0, %edx
; AVX512F-NEXT:    vextracti128 $1, %ymm0, %xmm0
; AVX512F-NEXT:    vpmovsxbd %xmm0, %zmm0
; AVX512F-NEXT:    vptestmd %zmm0, %zmm0, %k0
; AVX512F-NEXT:    kmovw %k0, %eax
; AVX512F-NEXT:    shll $16, %eax
; AVX512F-NEXT:    orl %edx, %eax
; AVX512F-NEXT:    shlq $32, %rax
; AVX512F-NEXT:    orq %rcx, %rax
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: v64i8:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpcmpgtb %zmm1, %zmm0, %k0
; AVX512BW-NEXT:    kmovq %k0, %rax
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
  %x = icmp sgt <64 x i8> %a, %b
  %res = bitcast <64 x i1> %x to i64
  ret i64 %res
}

define i8 @v8i64(<8 x i64> %a, <8 x i64> %b) {
; SSE-LABEL: v8i64:
; SSE:       # %bb.0:
; SSE-NEXT:    pcmpgtq %xmm7, %xmm3
; SSE-NEXT:    pcmpgtq %xmm6, %xmm2
; SSE-NEXT:    packssdw %xmm3, %xmm2
; SSE-NEXT:    pcmpgtq %xmm5, %xmm1
; SSE-NEXT:    pcmpgtq %xmm4, %xmm0
; SSE-NEXT:    packssdw %xmm1, %xmm0
; SSE-NEXT:    packssdw %xmm2, %xmm0
; SSE-NEXT:    packsswb %xmm0, %xmm0
; SSE-NEXT:    pmovmskb %xmm0, %eax
; SSE-NEXT:    # kill: def %al killed %al killed %eax
; SSE-NEXT:    retq
;
; AVX1-LABEL: v8i64:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vextractf128 $1, %ymm3, %xmm4
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm5
; AVX1-NEXT:    vpcmpgtq %xmm4, %xmm5, %xmm4
; AVX1-NEXT:    vpcmpgtq %xmm3, %xmm1, %xmm1
; AVX1-NEXT:    vpackssdw %xmm4, %xmm1, %xmm1
; AVX1-NEXT:    vextractf128 $1, %ymm2, %xmm3
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm4
; AVX1-NEXT:    vpcmpgtq %xmm3, %xmm4, %xmm3
; AVX1-NEXT:    vpcmpgtq %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vpackssdw %xmm3, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX1-NEXT:    vmovmskps %ymm0, %eax
; AVX1-NEXT:    # kill: def %al killed %al killed %eax
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: v8i64:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpcmpgtq %ymm3, %ymm1, %ymm1
; AVX2-NEXT:    vpcmpgtq %ymm2, %ymm0, %ymm0
; AVX2-NEXT:    vpackssdw %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vpermq {{.*#+}} ymm0 = ymm0[0,2,1,3]
; AVX2-NEXT:    vmovmskps %ymm0, %eax
; AVX2-NEXT:    # kill: def %al killed %al killed %eax
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: v8i64:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpcmpgtq %zmm1, %zmm0, %k0
; AVX512F-NEXT:    kmovw %k0, %eax
; AVX512F-NEXT:    # kill: def %al killed %al killed %eax
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: v8i64:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpcmpgtq %zmm1, %zmm0, %k0
; AVX512BW-NEXT:    kmovd %k0, %eax
; AVX512BW-NEXT:    # kill: def %al killed %al killed %eax
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
  %x = icmp sgt <8 x i64> %a, %b
  %res = bitcast <8 x i1> %x to i8
  ret i8 %res
}

define i8 @v8f64(<8 x double> %a, <8 x double> %b) {
; SSE-LABEL: v8f64:
; SSE:       # %bb.0:
; SSE-NEXT:    cmpltpd %xmm3, %xmm7
; SSE-NEXT:    cmpltpd %xmm2, %xmm6
; SSE-NEXT:    packssdw %xmm7, %xmm6
; SSE-NEXT:    cmpltpd %xmm1, %xmm5
; SSE-NEXT:    cmpltpd %xmm0, %xmm4
; SSE-NEXT:    packssdw %xmm5, %xmm4
; SSE-NEXT:    packssdw %xmm6, %xmm4
; SSE-NEXT:    packsswb %xmm0, %xmm4
; SSE-NEXT:    pmovmskb %xmm4, %eax
; SSE-NEXT:    # kill: def %al killed %al killed %eax
; SSE-NEXT:    retq
;
; AVX1-LABEL: v8f64:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vcmpltpd %ymm1, %ymm3, %ymm1
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm3
; AVX1-NEXT:    vpackssdw %xmm3, %xmm1, %xmm1
; AVX1-NEXT:    vcmpltpd %ymm0, %ymm2, %ymm0
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm2
; AVX1-NEXT:    vpackssdw %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX1-NEXT:    vmovmskps %ymm0, %eax
; AVX1-NEXT:    # kill: def %al killed %al killed %eax
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: v8f64:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vcmpltpd %ymm1, %ymm3, %ymm1
; AVX2-NEXT:    vcmpltpd %ymm0, %ymm2, %ymm0
; AVX2-NEXT:    vpackssdw %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vpermq {{.*#+}} ymm0 = ymm0[0,2,1,3]
; AVX2-NEXT:    vmovmskps %ymm0, %eax
; AVX2-NEXT:    # kill: def %al killed %al killed %eax
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: v8f64:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vcmpltpd %zmm0, %zmm1, %k0
; AVX512F-NEXT:    kmovw %k0, %eax
; AVX512F-NEXT:    # kill: def %al killed %al killed %eax
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: v8f64:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vcmpltpd %zmm0, %zmm1, %k0
; AVX512BW-NEXT:    kmovd %k0, %eax
; AVX512BW-NEXT:    # kill: def %al killed %al killed %eax
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
  %x = fcmp ogt <8 x double> %a, %b
  %res = bitcast <8 x i1> %x to i8
  ret i8 %res
}
