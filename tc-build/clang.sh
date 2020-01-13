sudo apt install bison ca-certificates ccache clang cmake curl file flex gcc g++ git make ninja-build python3 texinfo zlib1g-dev lld
git clone https://github.com/ClangBuiltLinux/tc-build
cd tc-build
./build-llvm.py --projects "clang;compiler-rt;lld;polly" --pgo --targets "ARM;AArch64;X86" --lto full
./build-binutils.py --targets arm aarch64 x86_64

rm -fr install/include
rm -f install/lib/*.a install/lib/*.la

for f in $(find install -type f -exec file {} \; | grep 'not stripped' | awk '{print $1}'); do
	strip ${f: : -1}
done

for bin in $(find install -type f -exec file {} \; | grep 'ELF .* interpreter' | awk '{print $1}'); do
	bin="${bin: : -1}"

	if ldd "$bin" | grep -q "not found"; then
		echo "Setting rpath on $bin"
		patchelf --set-rpath '$ORIGIN/../lib' "$bin"
	fi
done
