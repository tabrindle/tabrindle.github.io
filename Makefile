.DEFAULT_GOAL:= build
SHELL := /bin/bash

build:
	@hugo
	
clean:
	@rm -rf ./public