# Autenticacao e dados na nuvem

O prototipo usa Supabase Auth para contas reais, Supabase Postgres com RLS para os dados e um bucket privado para arquivos. O `anonKey` e uma chave publica do cliente; nunca coloque uma `service_role` key neste site.

## Configurar

1. Crie um projeto em Supabase.
2. No SQL Editor do projeto, execute `supabase/schema.sql`.
3. Em Project Settings > API, copie a Project URL e a chave publica (anon/publishable) para `supabase-config.js`:

```js
window.SUPABASE_CONFIG = {
  url: "https://SEU-PROJETO.supabase.co",
  anonKey: "SUA_CHAVE_PUBLICA"
};
```

4. Em Authentication > URL Configuration, use como Site URL:
   `https://helicleiton.github.io/entrelinhas-gestao-cultural/`
5. Em Authentication > Providers, habilite Google. Crie um OAuth Client do tipo Web no Google Cloud Console e cadastre como Authorized redirect URI a callback mostrada na tela do provider Google do Supabase (normalmente `https://SEU-PROJETO.supabase.co/auth/v1/callback`). Configure o Client ID e Client Secret somente no painel do Supabase.
6. Em Supabase > Authentication > URL Configuration > Redirect URLs, adicione:
   `https://helicleiton.github.io/entrelinhas-gestao-cultural/`
7. Publique `supabase-config.js` no GitHub. A URL e a chave anon/publishable podem ser públicas; a segurança dos dados e garantida pelas políticas RLS, não por esconder essa chave.

O login por e-mail usa confirmação de endereço conforme a configuração de Authentication do projeto. Até configurar o Supabase, o botão de demonstração continua disponível e o cadastro real informa que falta conectar o serviço.
