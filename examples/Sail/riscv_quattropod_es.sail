/*=======================================================================================*/
/*  RISCV Sail Model                                                                     */
/*                                                                                       */
/*  This Sail RISC-V architecture model, comprising all files and                        */
/*  directories except for the snapshots of the Lem and Sail libraries                   */
/*  in the prover_snapshots directory (which include copies of their                     */
/*  licences), is subject to the BSD two-clause licence below.                           */
/*                                                                                       */
/*  Copyright (c) 2017-2025                                                              */
/*    Prashanth Mundkur                                                                  */
/*    Rishiyur S. Nikhil and Bluespec, Inc.                                              */
/*    Jon French                                                                         */
/*    Brian Campbell                                                                     */
/*    Robert Norton-Wright                                                               */
/*    Alasdair Armstrong                                                                 */
/*    Thomas Bauereiss                                                                   */
/*    Shaked Flur                                                                        */
/*    Christopher Pulte                                                                  */
/*    Peter Sewell                                                                       */
/*    Alexander Richardson                                                               */
/*    Hesham Almatary                                                                    */
/*    Jessica Clarke                                                                     */
/*    Microsoft, for contributions by Robert Norton-Wright and Nathaniel Wesley Filardo  */
/*    Peter Rugg                                                                         */
/*    Aril Computer Corp., for contributions by Scott Johnson                            */
/*    Philipp Tomsich                                                                    */
/*    VRULL GmbH, for contributions by its employees                                     */
/*    LabWare                                                                            */
/*                                                                                       */
/*  All rights reserved.                                                                 */
/*                                                                                       */
/*  This software was developed by the above within the Rigorous                         */
/*  Engineering of Mainstream Systems (REMS) project, partly funded by                   */
/*  EPSRC grant EP/K008528/1, at the Universities of Cambridge and                       */
/*  Edinburgh.                                                                           */
/*                                                                                       */
/*  This software was developed by SRI International and the University of               */
/*  Cambridge Computer Laboratory (Department of Computer Science and                    */
/*  Technology) under DARPA/AFRL contract FA8650-18-C-7809 ("CIFV"), and                 */
/*  under DARPA contract HR0011-18-C-0016 ("ECATS") as part of the DARPA                 */
/*  SSITH research programme.                                                            */
/*                                                                                       */
/*  This project has received funding from the European Research Council                 */
/*  (ERC) under the European Union’s Horizon 2020 research and innovation                */
/*  programme (grant agreement 789108, ELVER).                                           */
/*                                                                                       */
/*                                                                                       */
/*  Redistribution and use in source and binary forms, with or without                   */
/*  modification, are permitted provided that the following conditions                   */
/*  are met:                                                                             */
/*  1. Redistributions of source code must retain the above copyright                    */
/*     notice, this list of conditions and the following disclaimer.                     */
/*  2. Redistributions in binary form must reproduce the above copyright                 */
/*     notice, this list of conditions and the following disclaimer in                   */
/*     the documentation and/or other materials provided with the                        */
/*     distribution.                                                                     */
/*                                                                                       */
/*  THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS''                   */
/*  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED                    */
/*  TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A                      */
/*  PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR                  */
/*  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,                         */
/*  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT                     */
/*  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF                     */
/*  USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND                  */
/*  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,                   */
/*  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT                   */
/*  OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF                   */
/*  SUCH DAMAGE.                                                                         */
/*=======================================================================================*/

$span start PREAMBLE

default Order dec
$include <prelude.sail>

$span end

val sign_extend : forall 'n 'm, 'm >= 'n. (implicit('m), bits('n)) -> bits('m)
val zero_extend : forall 'n 'm, 'm >= 'n. (implicit('m), bits('n)) -> bits('m)

function sign_extend(m, v) = sail_sign_extend(v, m)
function zero_extend(m, v) = sail_zero_extend(v, m)

val bool_to_bits : bool -> bits(1)
function bool_to_bits x = if x then 0b1 else 0b0

infix 4 <_s
infix 4 >=_s
infix 4 <_u
infix 4 >=_u
infix 4 <=_u

val operator <_s  : forall 'n, 'n > 0. (bits('n), bits('n)) -> bool
val operator >=_s : forall 'n, 'n > 0. (bits('n), bits('n)) -> bool
val operator <_u  : forall 'n. (bits('n), bits('n)) -> bool
val operator >=_u : forall 'n. (bits('n), bits('n)) -> bool
val operator <=_u : forall 'n. (bits('n), bits('n)) -> bool

function operator <_s  (x, y) = signed(x) < signed(y)
function operator >=_s (x, y) = signed(x) >= signed(y)
function operator <_u  (x, y) = unsigned(x) < unsigned(y)
function operator >=_u (x, y) = unsigned(x) >= unsigned(y)
function operator <=_u (x, y) = unsigned(x) <= unsigned(y)

val sub_vec = {c: "sub_bits", _: "sub_vec"} : forall 'n. (bits('n), bits('n)) -> bits('n)

overload operator - = {sub_vec}

infix 7 >>
infix 7 <<

val "shift_bits_right" : forall 'n 'm. (bits('n), bits('m)) -> bits('n)
val "shift_bits_left"  : forall 'n 'm. (bits('n), bits('m)) -> bits('n)

overload operator >> = {shift_bits_right}
overload operator << = {shift_bits_left}

val xor_vec = {c: "xor_bits", _: "xor_vec"} : forall 'n. (bits('n), bits('n)) -> bits('n)

overload operator ^ = {xor_vec}

function shift_right_arith64 (v : bits(64), shift : bits(6)) -> bits(64) =
    let v128 : bits(128) = sign_extend(v) in
    (v128 >> shift)[63..0]

function shift_right_arith32 (v : bits(32), shift : bits(5)) -> bits(32) =
    let v64 : bits(64) = sign_extend(v) in
    (v64 >> shift)[31..0]

type xlen       : Int = 64
type xlen_bytes : Int = 8
type xlenbits         = bits(xlen)

type regbits = bits(5)
type regidx =  bits(5)

val zeros : forall 'n, 'n >= 0. int('n) -> bits('n)
function zeros n = replicate_bits(0b0, n)

/* Architectural state */

enum retire_status = {
  RETIRE_SUCCESS,  /* Instruction executed successfully */
  RETIRE_FAIL      /* Instruction execution failed (invalid instruction, ...) */
}

struct core_state = {
  /* Register bank */
  /* 0   zero*/
  /* 1*/ ra : xlenbits,
  /* 2*/ sp : xlenbits,
  /* 3*/ gp : xlenbits,
  /* 4*/ tp : xlenbits,
  /* 5*/ t0 : xlenbits,
  /* 6*/ t1 : xlenbits,
  /* 7*/ t2 : xlenbits,
  /* 8*/ s0 : xlenbits,
  /* 9*/ s1 : xlenbits,
  /*10*/ a0 : xlenbits,
  /*11*/ a1 : xlenbits,
  /*12*/ a2 : xlenbits,
  /*13*/ a3 : xlenbits,
  /*15*/ a4 : xlenbits,
  /*16*/ a5 : xlenbits,

  /* Program counter */
         PC : xlenbits,
     nextPC : xlenbits,

  /* Status */
     status : retire_status
}


val rX : (core_state, regbits) -> xlenbits
function rX (s, r) = {
  let rn = unsigned(r);
  match rn {
     0  => zero_extend(0x0),
     1  => s.ra,
     2  => s.sp,
     3  => s.gp,
     4  => s.tp,
     5  => s.t0,
     6  => s.t1,
     7  => s.t2,
     8  => s.s0,
     9  => s.s1,
    10  => s.a0,
    11  => s.a1,
    12  => s.a2,
    13  => s.a3,
    14  => s.a4,
    15  => s.a5
  }
}

val wX : (core_state, regbits, xlenbits) -> core_state

function wX (s, r, v) = {
  let rn = unsigned(r);
  match rn {
     0  => s,
     1  => { s with ra = v },
     2  => { s with sp = v },
     3  => { s with gp = v },
     4  => { s with tp = v },
     5  => { s with t0 = v },
     6  => { s with t1 = v },
     7  => { s with t2 = v },
     8  => { s with s0 = v },
     9  => { s with s1 = v },
    10  => { s with a0 = v },
    11  => { s with a1 = v },
    12  => { s with a2 = v },
    13  => { s with a3 = v },
    14  => { s with a4 = v },
    15  => { s with a5 = v }
  }
}

val rPC : (core_state) -> xlenbits

function rPC (s) = {
  s.PC
}

val wPC : (core_state, xlenbits) -> core_state

function wPC (s, v) = {
  s with nextPC = v
}

val retire : (core_state, retire_status) -> core_state

function retire (s, v) = {
  s with status = v
}


register PC : xlenbits

/* Accessors for memory */
val MEMr = impure { lem: "MEMr", coq: "MEMr", _ : "read_ram" } : forall 'n 'm, 'n >= 0.
   (int('m), int('n), bits('m), bits('m)) -> bits(8 * 'n)

val read_mem : forall 'n, 'n >= 0. (xlenbits, int('n)) -> bits(8 * 'n)
function read_mem(addr, width) =
    MEMr(sizeof(xlen), width, zero_extend(0x0), addr)

enum iop = {
  RISCV_ADDI,
  RISCV_SLTI,
  RISCV_SLTIU,
  RISCV_XORI,
  RISCV_ORI,
  RISCV_ANDI
}

mapping encdec_iop : iop <-> bits(3) = {
  RISCV_ADDI  <-> 0b000,
  RISCV_SLTI  <-> 0b010,
  RISCV_SLTIU <-> 0b011,
  RISCV_ANDI  <-> 0b111,
  RISCV_ORI   <-> 0b110,
  RISCV_XORI  <-> 0b100
}

enum bop = {
  RISCV_BEQ,
  RISCV_BNE,
  RISCV_BLT,
  RISCV_BGE,
  RISCV_BLTU,
  RISCV_BGEU
}

mapping encdec_bop : bop <-> bits(3) = {
  RISCV_BEQ  <-> 0b000,
  RISCV_BNE  <-> 0b001,
  RISCV_BLT  <-> 0b100,
  RISCV_BGE  <-> 0b101,
  RISCV_BLTU <-> 0b110,
  RISCV_BGEU <-> 0b111
}

enum rop = {
  RISCV_ADD,
  RISCV_SUB,
  RISCV_SLL,
  RISCV_SLT,
  RISCV_SLTU,
  RISCV_XOR,
  RISCV_SRL,
  RISCV_SRA,
  RISCV_OR,
  RISCV_AND
}

/* Instruction decode and execute */
scattered union ast

val decode : bits(32) -> ast

val execute : (core_state, ast) -> core_state

/* ****************************************************************** */

union clause ast = ITYPE : (bits(12), regidx, regidx, iop)

function clause decode imm : bits(12) @ rs1 : regbits @ op : bits(3) @ rd : regbits @ 0b0010011
  = ITYPE(imm, rs1, rd, encdec_iop(op))

function clause execute (core, ITYPE (imm, rs1, rd, op)) = {
  let rs1_val = rX(core, rs1);
  let immext : xlenbits = sign_extend(imm);
  let result : xlenbits = match op {
    RISCV_ADDI  => rs1_val + immext,
    RISCV_SLTI  => zero_extend(bool_to_bits(rs1_val <_s immext)),
    RISCV_SLTIU => zero_extend(bool_to_bits(rs1_val <_u immext)),
    RISCV_ANDI  => rs1_val & immext,
    RISCV_ORI   => rs1_val | immext,
    RISCV_XORI  => rs1_val ^ immext
  };
  let core = wX(core, rd, result);
  retire(core, RETIRE_SUCCESS)
}

/* ****************************************************************** */
union clause ast = BTYPE : (bits(13), regidx, regidx, bop)

function clause decode imm7_6 : bits(1) @ imm7_5_0 : bits(6) @ rs2 : regidx @ rs1 : regidx @ op : bits(3) @ imm5_4_1 : bits(4) @ imm5_0 : bits(1) @ 0b1100011
  = BTYPE(imm7_6 @ imm5_0 @ imm7_5_0 @ imm5_4_1 @ 0b0, rs2, rs1, encdec_bop(op))

function clause execute (core, BTYPE(imm, rs2, rs1, op)) = {
  let rs1_val = rX(core, rs1);
  let rs2_val = rX(core, rs2);
  let taken : bool = match op {
    RISCV_BEQ  => rs1_val == rs2_val,
    RISCV_BNE  => rs1_val != rs2_val,
    RISCV_BLT  => rs1_val <_s rs2_val,
    RISCV_BGE  => rs1_val >=_s rs2_val,
    RISCV_BLTU => rs1_val <_u rs2_val,
    RISCV_BGEU => rs1_val >=_u rs2_val
  };
  let target : xlenbits = rPC(core) + sign_extend(imm);
  /*
   * For simplicity, we omit target address validation
   * (memory unmapped or not executable and so on)
   */
  if taken then {
    let core = wPC(core, target);
    retire(core, RETIRE_SUCCESS)
  } else {
    retire(core, RETIRE_SUCCESS)
  }
}

/* ****************************************************************** */

union clause ast = RTYPE : (regidx, regidx, regidx, rop)

function clause decode 0b0100000 @ rs2 : regidx @ rs1 : regidx@ 0b000 @ rd : regidx @ 0b0110011
  = RTYPE(rs2, rs1, rd, RISCV_SUB)

function clause execute (core, RTYPE(rs2, rs1, rd, op)) = {
  let rs1_val = rX(core, rs1);
  let rs2_val = rX(core, rs2);
  let result : xlenbits = match op {
    RISCV_ADD  => rs1_val + rs2_val,
    RISCV_SLT  => zero_extend(bool_to_bits(rs1_val <_s rs2_val)),
    RISCV_SLTU => zero_extend(bool_to_bits(rs1_val <_u rs2_val)),
    RISCV_AND  => rs1_val & rs2_val,
    RISCV_OR   => rs1_val | rs2_val,
    RISCV_XOR  => rs1_val ^ rs2_val,
    RISCV_SLL  => if   sizeof(xlen) == 32
                  then rs1_val << (rs2_val[4..0])
                  else rs1_val << (rs2_val[5..0]),
    RISCV_SRL  => if   sizeof(xlen) == 32
                  then rs1_val >> (rs2_val[4..0])
                  else rs1_val >> (rs2_val[5..0]),
    RISCV_SUB  => rs1_val - rs2_val,
    RISCV_SRA  => if   sizeof(xlen) == 32
                  then shift_right_arith32(rs1_val, rs2_val[4..0])
                  else shift_right_arith64(rs1_val, rs2_val[5..0])
  };
  let core = wX(core, rd, result);
  retire(core, RETIRE_SUCCESS)
}

/* ****************************************************************** */

union clause ast = RISCV_JALR : (bits(12), regidx, regidx)

function clause decode imm : bits(12) @ rs1 : regidx @ 0b000 @ rd :regidx @ 0b1100111
  = RISCV_JALR(imm, rs1, rd)

function clause execute (core, RISCV_JALR(imm, rs1, rd)) = {
  let target : xlenbits = rX(core, rs1) + sign_extend(imm);
  /*
   * For simplicity, we omit target address validation
   * (memory unmapped or not executable and so on)
   */
  let core = wPC(core, target);
  retire(core, RETIRE_SUCCESS)

}

/* ****************************************************************** */

union clause ast = INVALID : (unit)

function clause decode _ = INVALID(())

// Otherwise Sail will complain about unmatched cases
function clause execute (core, _) = retire(core, RETIRE_FAIL)


val decode_and_execute : (core_state, bits(32)) -> core_state

function decode_and_execute(core, enc) = {
  let ast = decode(enc);
  let core = wPC(core, PC + 0x0000_0000_0000_0004);
  let core = execute(core, decode(enc));
  let core = { core with PC = core.nextPC };
  core
}
