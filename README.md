# 🥺

🥺 is sudo at home.

[Writeup](https://xeiaso.net/blog/%F0%9F%A5%BA)

## Building release assets
```
waifuctl create -d ubuntu-18.04 -h ontos -m 1024 --disk-size 25
cargo install cargo-deb
cargo deb
```

```
waifuctl create -d amazon-linux-2 -h ontos -m 1024 --disk-size 25
cargo install generate-rpm
cargo build --release
```

## Downloads
Download from [the
fileserver](https://pneuma.shark-harmonic.ts.net/.within/xn--ts9h/).
