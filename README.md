# pdal, lastools and py3dtiles docker image

## How to build

```bash
docker build -t las-processing .
```

## How to run

### pdal

```bash
vim merge-to-laz.json
```

```json
[
  "/work/test*.las",
  "/work/merged.laz"
]
```

```bash
docker run -u `id -u`:`id -g` -v $(pwd):/work --rm las-processing pdal pipeline /work/merge-to-laz.json
```

### lastools

```bash
docker run -u `id -u`:`id -g` -v $(pwd):/work --rm las-processing lasinfo64 /work/merged.las
```

### py3dtiles

```bash
docker run -e NUMBA_CACHE_DIR=/tmp/numba_cache -u `id -u`:`id -g` -v $(pwd):/work -v --rm las-processing py3dtiles convert --pyproj-always-xy --out /work/3dtiles --srs_out 4978 /work/merged.las
```
