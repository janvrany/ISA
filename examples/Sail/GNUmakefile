all: ../Jib/riscv_quattropod.ir

../Jib/riscv_quattropod.ir: riscv_quattropod.sail
	sail --all-warnings --list-files --isla --isla-preserve decode_and_execute $<  -o ../Jib/riscv_quattropod

clean:
	rm ../Jib/riscv_quattropod.ir