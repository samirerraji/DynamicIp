FROM amazonlinux:latest as installer
RUN yum update -y \
  && yum install -y unzip \
  && curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscli-exe-linux-x86_64.zip \
  && unzip awscli-exe-linux-x86_64.zip \
  # The --bin-dir is specified so that we can copy the
  # entire bin directory from the installer stage into
  # into /usr/local/bin of the final stage without
  # accidentally copying over any other executables that
  # may be present in /usr/local/bin of the installer stage.
  && ./aws/install --bin-dir /aws-cli-bin/

FROM amazonlinux:latest
COPY --from=installer /usr/local/aws-cli/ /usr/local/aws-cli/
COPY --from=installer /aws-cli-bin/ /usr/local/bin/
RUN yum update -y \
  && yum install -y less groff jq \
  && yum clean all

#probably should mount /root/.aws
COPY DynamicIp.sh /root/DynamicIp.sh
COPY settings/credentials.sample /root/
COPY settings/settings.json.sample /root/

ENTRYPOINT ["/root/DynamicIp.sh"]
