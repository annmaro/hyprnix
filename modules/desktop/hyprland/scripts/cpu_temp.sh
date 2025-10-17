#!/usr/bin/env bash
sensors -C | grep 'CPU:' | awk '{print $2}' 