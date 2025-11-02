FROM quay.io/openshift/origin-cli:4.18 as cli

FROM quay.io/ansible/ansible-runner:stable-2.12-latest
COPY --from=cli /usr/bin/oc /usr/bin/oc
# COPY /licenses /licenses
RUN pip3 install kubernetes openshift
RUN ansible-galaxy collection install kubernetes.core
RUN ansible-galaxy collection install ansible.windows
# RUN ansible-galaxy collection install community.windows
RUN chmod 777 /home/runner/.ansible && chmod 777 /home/runner/.ansible/tmp
RUN mkdir /.ansible && chmod 777 /.ansible
USER 65534:65534
