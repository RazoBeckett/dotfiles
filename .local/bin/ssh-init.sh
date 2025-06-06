#!/bin/env sh

ssh_string="$1"

if [ -z "$ssh_string" ]; then
	echo "Usage: $(basename "$0") <user@host>"
	exit 1
fi

USER_NAME=$(printf "%s" "$ssh_string" | cut -d'@' -f1)
HOST_NAME=$(printf "%s" "$ssh_string" | cut -d'@' -f2)

if [ -z "$USER_NAME" ] || [ -z "$HOST_NAME" ]; then
	echo "Usage: $0 <user@host>"
	exit 1
fi

TMP_PUB="/tmp/tpm"

if ssh-keygen -D /usr/lib/pkcs11/libtpm2_pkcs11.so >"$TMP_PUB" 2>/dev/null && grep -q "ecdsa-sha2" "$TMP_PUB"; then
	PUBLIC_KEY="$TMP_PUB"
else
	echo "No TPM-backed key found, falling back to ~/.ssh/generic..."
	KEY_PATH="$HOME/.ssh/generic"
	if [ ! -f "$KEY_PATH" ]; then
		echo "Generating SSH key..."
		if ! ssh-keygen -t ed25519 -f "$KEY_PATH" -N "" -C "$USER_NAME@$HOST_NAME"; then
			echo "Failed to generate SSH key"
			exit 1
		fi
	else
		echo "SSH key already exists, using it."
	fi
	PUBLIC_KEY="$KEY_PATH"
fi

echo "Copying public key to $USER_NAME@$HOST_NAME"

if ! ssh-copy-id -i "$PUBLIC_KEY" "$USER_NAME@$HOST_NAME"; then
	echo "Failed to copy public key to $USER_NAME@$HOST_NAME"
	exit 1
fi

echo "Public key copied successfully to $USER_NAME@$HOST_NAME"
