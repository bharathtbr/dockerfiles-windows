$version=$(select-string -Path Dockerfile -Pattern "ENV CONSUL_VERSION").ToString().split()[-1]
docker tag consul bharathtbr/consul-windows:$version
docker push bharathtbr/consul-windows:$version
docker tag consul bharathtbr/consul-windows:latest
docker push bharathtbr/consul-windows:latest
