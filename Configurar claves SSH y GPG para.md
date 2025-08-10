¡Perfecto! Aquí tienes una guía paso a paso para configurar dos claves SSH diferentes: una para Bitbucket y otra para GitHub en el mismo equipo.

---

## 1. Genera dos claves SSH diferentes

Abre la terminal y ejecuta estos comandos (puedes cambiar los nombres según prefieras):

```bash
# Para Bitbucket
ssh-keygen -t ed25519 -C "tu-email@bitbucket" -f ~/.ssh/id_ed25519_bitbucket

# Para GitHub
ssh-keygen -t ed25519 -C "tu-email@github" -f ~/.ssh/id_ed25519_github
```

Presiona enter cuando te pida passphrase (puedes poner una o dejarla vacía).

---

## 2. Agrega las claves al agente SSH

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519_bitbucket
ssh-add ~/.ssh/id_ed25519_github
```

---

## 3. Copia las claves públicas y súbelas a cada cuenta

```bash
cat ~/.ssh/id_ed25519_bitbucket.pub
cat ~/.ssh/id_ed25519_github.pub
```
- Pon el contenido de cada archivo en la sección "SSH Keys" de tu perfil de Bitbucket y GitHub respectivamente.

---

## 4. Configura el archivo SSH `~/.ssh/config`

Edita (o crea, si no existe) el archivo `~/.ssh/config` y añade lo siguiente:

```sshconfig
# Bitbucket
Host bitbucket.org
    HostName bitbucket.org
    User git
    IdentityFile ~/.ssh/id_ed25519_bitbucket

# GitHub
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_github
```

---

## 5. Verifica que funciona

Prueba la conexión con cada servicio:

```bash
ssh -T git@github.com
ssh -T git@bitbucket.org
```

Deberías ver un mensaje de bienvenida de cada uno.

---

¡Listo! Ahora cada vez que uses git con bitbucket.org o github.com, se usará la clave correspondiente automáticamente. Si tienes dudas o necesitas un flujo para Windows, ¡avísame!

¡Claro! Aquí tienes una guía para configurar dos claves GPG diferentes: una para Bitbucket y otra para GitHub, en el mismo equipo. Así podrás firmar tus commits para cada plataforma con la clave correspondiente.

---

## 1. Genera dos claves GPG diferentes

Ejecuta dos veces el siguiente comando, cambiando el correo electrónico y nombre para cada cuenta (GitHub y Bitbucket):

```bash
# Para Bitbucket
gpg --full-generate-key
# (Pon tu nombre y correo de Bitbucket, elige tipo "RSA and RSA", tamaño 4096, y una fecha de expiración o "0" para nunca)

# Para GitHub
gpg --full-generate-key
# (Pon tu nombre y correo de GitHub, igual que arriba)
```

**Guarda la huella digital (fingerprint) de cada clave.**  
Puedes ver las claves con:
```bash
gpg --list-secret-keys --keyid-format=long
```

---

## 2. Exporta las claves públicas y agrégalas a cada cuenta

```bash
# Bitbucket
gpg --armor --export TU_GPG_ID_BITBUCKET

# GitHub
gpg --armor --export TU_GPG_ID_GITHUB
```

- Ve a Bitbucket: Settings → GPG keys → Add key (pega la pública).
- Ve a GitHub: Settings → SSH and GPG keys → New GPG Key (pega la pública).

---

## 3. Configura Git para usar la clave correcta según el repositorio

Configura el correo y GPG key para cada repositorio (o puedes hacerlo global si solo usas una cuenta por equipo):

```bash
# Dentro del repo de Bitbucket
git config user.email "tu-email@bitbucket"
git config user.signingkey TU_GPG_ID_BITBUCKET

# Dentro del repo de GitHub
git config user.email "tu-email@github"
git config user.signingkey TU_GPG_ID_GITHUB

# Asegúrate de habilitar la firma automática:
git config commit.gpgsign true
```

Puedes automatizar esto creando un archivo `.gitconfig` por cada proyecto o agregando condiciones en tu `~/.gitconfig` global usando [includeIf](https://git-scm.com/docs/git-config#_conditional_includes):

````ini
# Ejemplo en ~/.gitconfig
[includeIf "gitdir:~/path/a/tu/repo-bitbucket/"]
    path = ~/.gitconfig-bitbucket
[includeIf "gitdir:~/path/a/tu/repo-github/"]
    path = ~/.gitconfig-github
````

Luego, en cada archivo `.gitconfig-bitbucket` y `.gitconfig-github`:

````ini
[user]
    email = tu-email@bitbucket
    signingkey = TU_GPG_ID_BITBUCKET
[commit]
    gpgsign = true
````

---

## 4. Opcional: Configura el agente GPG

Para evitar que pida la passphrase cada vez, puedes usar un agente GPG (ya viene en la mayoría de sistemas modernos), por ejemplo con `gpg-agent` y `pinentry`.

---

## 5. Verifica la firma

Haz un commit y verifica con:

```bash
git log --show-signature
```

O en GitHub/Bitbucket debería aparecer como "Verified".

---
