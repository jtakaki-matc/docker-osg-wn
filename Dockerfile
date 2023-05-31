# Default to AL8 builds
ARG IMAGE_BASE=quay.io/almalinux/almalinux:8
FROM $IMAGE_BASE

ARG OS_VER=al8
ARG OSG_RELEASE=3.6
ARG BASE_YUM_REPO=release
ARG BUILDDATE

LABEL name="OSG ${OSG_RELEASE} Worker Node Client on EL ${OS_VER} + ${BASE_YUM_REPO} repos"
LABEL build-date=${BUILDDATE}

RUN yum -y install https://repo.opensciencegrid.org/osg/${OSG_RELEASE}/osg-${OSG_RELEASE}-${OS_VER}-release-latest.rpm \
                   epel-release \
                   yum-utils && \
    if [[ ${OS_VER} == el7 ]]; then \
        yum -y install yum-plugin-priorities; \
    fi && \
    if [[ ${OS_VER} == el8 ]]; then \
        yum-config-manager --enable powertools; \
    fi && \
    if [[ ${OS_VER} == al8 ]]; then \
        [[${OS_VER} == el8]]; \
    fi && \
    if [[ ${BASE_YUM_REPO} == "devel" ]]; then \
        yum-config-manager --enable osg-development; \
        if [[ ${OSG_RELEASE} == "3.5" ]]; then \
            yum-config-manager --enable osg-upcoming-development; \
        fi; \
    elif [[ ${BASE_YUM_REPO} != "release" ]]; then \
        yum-config-manager --enable osg-${BASE_YUM_REPO}; \
        if [[ ${OSG_RELEASE} == "3.5" ]]; then \
            yum-config-manager --enable osg-upcoming-${BASE_YUM_REPO}; \
        fi; \
    elif [[ ${OSG_RELEASE} == "3.5" ]]; then \
        yum-config-manager --enable osg-upcoming; \
    fi && \
    yum -y install   \
                   osg-wn-client \
                   redhat-lsb-core \
                   openssh-server \
                   apptainer && \
    yum clean all && \
    rm -rf /var/cache/yum/*
