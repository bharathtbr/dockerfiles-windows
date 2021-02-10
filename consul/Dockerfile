# escape=`
FROM mcr.microsoft.com/windows/servercore:ltsc2019 as download19
ENV CONSUL_VERSION 1.9.3

RUN powershell -Command $ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';$AllProtocolsIzenda = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12';`
            [System.Net.ServicePointManager]::SecurityProtocol = $AllProtocolsIzenda;`
    Invoke-WebRequest $('https://releases.hashicorp.com/consul/{0}/consul_{0}_windows_amd64.zip' -f $env:CONSUL_VERSION) -OutFile 'consul.zip' -UseBasicParsing ; `
    Expand-Archive -Path consul.zip -DestinationPath C:\download19 -Force ; `
    rm consul.zip ; `
    mkdir C:\download19\consul\data ; `
    mkdir C:\download19\consul\config

FROM mcr.microsoft.com/windows/servercore:ltsc2019
COPY --from=download19 /download19 /

# Expose the consul data directory as a volume since there's mutable state in there.
# VOLUME C:\consul\data

# Server RPC is used for communication between Consul clients and servers for internal
# request forwarding.
EXPOSE 8300

# Serf LAN and WAN (WAN is used only by Consul servers) are used for gossip between
# Consul agents. LAN is within the datacenter and WAN is between just the Consul
# servers in all datacenters.
EXPOSE 8301 8301/udp 8302 8302/udp

# CLI, HTTP, and DNS (both TCP and UDP) are the primary interfaces that applications
# use to interact with Consul.
EXPOSE 8400 8500 8600 8600/udp

ENTRYPOINT [ "C:\\consul.exe" ]

# By default you'll get an insecure single-node development server that stores
# everything in RAM, exposes a web UI and HTTP endpoints, and bootstraps itself.
# Don't use this configuration for production.
CMD ["agent", "-dev", "-client", "0.0.0.0"]

FROM mcr.microsoft.com/windows/servercore:1803 
ENV GIT_VERSION 2.30.1
ENV GIT_PATCH_VERSION 2
RUN mkdir C:\git2consul\cache
ADD chk.ps1 /windows/temp/chk.ps1
ADD gitconsul.json /git2consul/gitconsul.json
RUN powershell.exe -executionpolicy bypass c:\windows\temp\chk.ps1
RUN npm install git2consul-windows -g
CMD ["git2consul-windows","---config-file","C:\git2consul\gitconsul.json"]