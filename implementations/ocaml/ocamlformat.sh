for file in $(ls src/*.ml src/*.mli)
do
  ocamlformat -i $file
done
