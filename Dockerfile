#ARG NODE_VERSION=10
#RUN if [ ${NODE_VERSION} = 13 ] ; then ${NODE_VERSION} = "13-alpine" ; else ${NODE_VERSION} = ${NODE_VERSION} ; fi
#FROM node:${NODE_VERSION}
FROM node:10-alpine

#ENV NODE_VERSION = $NODE_VERSION

# Working Directory
WORKDIR /usr/src/rearc

# Copy project files to current working directory
COPY ./src ./src
COPY ./bin ./bin
COPY ./package.json ./

# Install all dependencies
#RUN npm Install 

# install dependencies
RUN npm install

# Expose container port
EXPOSE 3000

# Set directory for volume
VOLUME /var/lib/rearc

CMD ["node", "./src/000.js"]
