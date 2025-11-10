# daylinbox

Container definition for use with [distrobox](https://github.com/89luca89/distrobox).
It's loosely based on the existing container defined [here](https://github.com/containers/toolbox/blob/dcd4c4382c912f98c60e7abccc3de7aa8f786bdf/images/arch/Containerfile).

To use ensure `podman` is installed.
Then build the image:

```sh
./tasks.py build
```

Then create and enter a distrobox:

```sh
distrobox create -i daylinbox
distrobox enter daylinbox
```

`./extra-packages` was copied over from the original container build.
`./my-extra-packages` is the list of tools I want around in these containers.

## init

```sh
curl -fsSL https://git.dayl.in/daylin/daylinbox/raw/branch/main/init.py | python3 -
```


