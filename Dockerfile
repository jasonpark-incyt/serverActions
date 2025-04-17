# Build stage
FROM golang:1.23-alpine3.21 AS build
WORKDIR /app
COPY . .
RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app .

# Use as base image in Dockerfile:
FROM ghcr.io/jasonpark-incyt/serveractions:sha256-b6100d0e8e49f9e06bae5a70f754ca67dd76b160aa158758ce6e2b302af193c6

# Final stage
FROM alpine:3.21
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser
WORKDIR /app
COPY --from=build /app/app .
CMD ["./app"]