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
docker run -u `id -u`:`id -g` -v $(pwd):/work --rm las-processing py3dtiles /work/merged.las --srs_out 4978 --out /work/3dtiles
```