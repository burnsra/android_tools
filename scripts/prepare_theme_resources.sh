if [ "$*" == "clean" ]; then
  rm -rf res-final/
else
  rm -rf res-final/
  rsync -a res/ res-final/
  echo "Running pngcrush..."
  for png in `find res-final/ -type f -name \*.png`; do
      pngcrush -q $png $png.out 2>/dev/null >/dev/null && mv $png.out $png
  done
fi
