# VLE-5: DevOps CI/CD Virtual Lab - application image
#
# Pinned to a specific nginx:alpine digest-friendly tag (not "latest") so the
# build is reproducible: the same tag always produces the same base layer.
FROM nginx:1.27-alpine

# Remove the default nginx placeholder page, then ship our own.
RUN rm -rf /usr/share/nginx/html/*
COPY index.html /usr/share/nginx/html/index.html

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=3s CMD wget -q --spider http://localhost/ || exit 1

CMD ["nginx", "-g", "daemon off;"]
