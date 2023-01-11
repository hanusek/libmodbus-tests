## README 

build the container:
`docker build -f ./Dockerfile -t datahub-rust-ubuntu-18 .`

run the container:
`docker run --rm -v $PWD:/transfer -t datahub-rust-ubuntu-18`