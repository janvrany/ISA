all: ../Jib/riscv_quattropod.ir ../Jib/riscv_quattropod_es.ir

../Jib/riscv_quattropod.ir: riscv_quattropod.sail
	sail --all-warnings --list-files --isla --isla-preserve decode_and_execute $<  -o ../Jib/riscv_quattropod

../Jib/riscv_quattropod_es.ir: riscv_quattropod_es.sail
	sail --all-warnings --list-files --isla --isla-preserve decode_and_execute $<  -o ../Jib/riscv_quattropod_es
	sed -i -e 's/%3\./z3zE/g' $@

clean:
	rm ../Jib/riscv_quattropod.ir ../Jib/riscv_quattropod_es.ir