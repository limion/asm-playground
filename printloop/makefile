print_loop: print_loop.o
	ld -o print_loop print_loop.o -lSystem -syslibroot `xcrun -sdk macosx --show-sdk-path` -e _start -arch arm64

print_loop.o: print_loop.s
	as -arch arm64 -o print_loop.o -g print_loop.s
