# Instruções de Configuração

## Sumário

- [Sumário](#sumário)
- [Como rodar um ambiente local de desenvolvimento com Docker Compose](#como-rodar-um-ambiente-local-de-desenvolvimento-com-docker-compose)
    - [Clonar este repositório](#clonar-este-repositório)
    - [Construir as imagens Docker](#construir-as-imagens-docker)
    - [Subir a aplicação, o servidor do banco de dados, o redis-cache e o redis-queue](#subir-a-aplicação-o-servidor-do-banco-de-dados-o-redis-cache-e-o-redis-queue)
    - [Preenchendo cadastro inicial de organização](#preenchendo-cadastro-inicial-de-organização)
    - [Acessando a organização com _admin_](#acessando-a-organização-com-admin)
- [Como rodar um ambiente público de produção com Docker Compose](#como-rodar-um-ambiente-público-de-produção-com-docker-compose)
    - [Clonar este repositório](#clonar-este-repositório-1)
    - [Construir as imagens Docker](#construir-as-imagens-docker-1)
    - [Configurar variáveis de ambiente](#configurar-variáveis-de-ambiente)
    - [Subir a aplicação, o servidor do banco de dados, o redis-cache e o redis-queue](#subir-a-aplicação-o-servidor-do-banco-de-dados-o-redis-cache-e-o-redis-queue-1)


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

## Como rodar um ambiente público de produção com Docker Compose
Obs: essas instruções são sobre como fazer o deploy manualmente, sem uma pipeline automatizada de deploy.

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
docker compose build
```

##### Configurar variáveis de ambiente

Seguem exemplos de variáveis de ambiente, e de como criar as "env files" utilizando o comando "tee".

```
# .envs/production/redis_queue
echo "\
REDIS_PORT=6379
REDIS_URL=redis://redis-queue:6379/1
" | sudo tee .envs/production/redis_queue


# .envs/production/redis_cache
echo "\
REDIS_CACHE_PORT=6380
REDIS_CACHE_URL=redis://redis-cache:6380
" | sudo tee .envs/production/redis_cache


# .envs/production/hostname
echo "\
HOSTNAME=18.229.164.77.sslip.io
ALLOW_HOSTS="18.229.164.77.sslip.io app localhost 127.0.0.1"
" | sudo tee .envs/production/hostname


# .envs/production/decidim_service
echo "\
SECRET_KEY_BASE="dasdaskdnasydbt"
DECIDIM_APPLICATION_NAME=Decide
DECIDIM_MAILER_SENDER="leonardomichalskim@gmail.com"
DECIDIM_DEFAULT_LOCALE=en
DECIDIM_AVAILABLE_LOCALES=en,pt-BR
DECIDIM_ENABLE_HTML_HEADER_SNIPPETS=true
DECIDIM_CURRENCY_UNIT=R$
DECIDIM_FORCE_SSL=true
MEETINGS_EMBEDDABLE_SERVICES=youtube.com twitch.tv meet.jit.si
INITIATIVES_DEFAULT_COMPONENTS=meetings
SMTP_USERNAME="leonardomichalskim@gmail.com"
SMTP_PASSWORD="joao"
SMTP_ADDRESS=smtp.18.229.164.77.sslip.io
SMTP_PORT=1025
SMTP_DOMAIN=example.com
SIDEKIQ_CONCURRENCY=2
RAILS_SERVE_STATIC_FILES=true
# RAILS_LOG_TO_JSON=true
OMNIAUTH_GOVBR_CLIENT_ID="test"
OMNIAUTH_GOVBR_SECRET_KEY="ds312abjdasvbhdb6767s"
OMNIAUTH_GOVBR_HOST=sso.staging.acesso.gov.br
OMNIAUTH_GOVBR_REDIRECT_URI=https://18.229.164.77.sslip.io/users/auth/govbr/callback
" | sudo tee .envs/production/decidim_service


# .envs/production/database
echo "\
DATABASE_HOST="postgres"
DATABASE_PORT="5432"
DATABASE_DB="joao"
DATABASE_USERNAME="joao"
DATABASE_PASSWORD="joao"
DATABASE_URL=postgres://joao:joao@postgres:5432/joao
POSTGRES_USERNAME=joao
POSTGRES_PASSWORD=joao
POSTGRES_PORT=5432
POSTGRES_HOST=postgres
# POSTGRES_DB="joao" # dont use
POSTGRES_URL=postgres://joao:joao@postgres:5432/joao
" | sudo tee .envs/production/database


# .envs/production/admin_password
echo "\
ADMIN_PASSWORD="joao"
" | sudo tee .envs/production/admin_password


# .envs/production/admin
echo "\
ADMIN_USERNAME="joao"
ADMIN_EMAIL="leonardomichalskim@gmail.com"
CERT_EMAIL="leonardomichalskim@gmail.com"
" | sudo tee .envs/production/admin
```

##### Subir a aplicação, o servidor do banco de dados, o redis-cache e o redis-queue

```
docker compose up
```
