# Instruções de Configuração

## Sumário

## Como rodar um ambiente local de desenvolvimento com Docker Compose

Requisitos:
* [Docker](https://docs.docker.com/get-docker/) instalado.
* [docker-compose](https://docs.docker.com/compose/) instalado.

##### Clonar este repositório

```
# Clonar o repositório
git clone https://github.com/leomichalski/trabalho-final-gces-2023-2
```

##### Construir as imagens Docker

```
docker compose -f docker-compose-local.yml build
```

##### Subir a aplicação, o servidor do banco de dados, o redis-cache e o redis-queue

```
docker compose -f docker-compose-local.yml up

# Acessar a aplicação em http://localhost:3000/system . O email do admin é "admin@email.com" e a senha é "admin-password".
```

##### Preenchendo cadastro inicial de organização

No primeiro _login_ você será direcionado para uma página para criar a primeira organização dentro da aplicação.

* No campo _Name_ preencha o nome da organização que você deseja criar. Por exemplo: `Organization 1`
* No campo _Reference prefix_ preencha o prefixo de identificacao da organização em minúsculo. Por exemplo `org1`
* No campo _Host_ preencha com o domínio que será utilizado na URL da organização. Nesse caso, preencha com `localhost`
* No campo _Secondary host_ não é necessário preencher nada.
* No campo _Organization admin name_ preencha o nome do administrador da organização. Por exemplo: `Decidim Admin`
* No campo _Organization admin email_  preencha o e-mail que será utilizado pelo administrador da organização. Por exemplo: `admin@email.com`
* Na seção _Organization locales_  selecione quais os idiomas estarão habilitados na organização, e a linguagem padrão. Por exemplo: `enabled: English, Português`, `default: Português`
* No campo _User registration mode_ selecione a opção `allow participants to register and login`
* Na seção _available authorizations_ selecione todos as opções.

Clique em `Create organization & invite admin`

##### Acessando a organização com _admin_

Depois de finalizar o cadastro da organização, abra o _mailcatcher_ no navegador acessando o endereço `http://127.0.0.1:1080`. Clique no e-mail enviado, e no conteúdo do e-mail clique em `Aceitar convite`.

---

Ao clicar na confirmação do e-mail, será aberta uma página para finalizar a criação do admin da organização.

* Preencha o _nickname_ com o apelido do administrador da organização. Por exemplo: `admin`
* Preencha os campos de senha com uma senha forte. Por exemplo: `dBzJR2TVF4Ns&Wf&VashYqU#gG8^TC!B4sb$BiNS` <small>(Não discuta, apenas copie e cole essa senha :clown:)</small>
* Marque os check-boxes e depois clique em `Salvar`
* No modal amarelo que aparece na tela, clique em `Reveja-os agora`.
* Em seguida clique em `I agree with the terms`
