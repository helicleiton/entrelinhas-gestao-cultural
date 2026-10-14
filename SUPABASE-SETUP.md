# Autenticacao e dados na nuvem
O frontend foi conectado ao projeto existente `playbackflix` (`egqwgyhpcdejxnwuweti`). O schema próprio Entrelinhas, RLS, bucket privado e redirect do GitHub Pages já foram aplicados. O projeto é compartilhado com PlaybackFlix; mantenha as configurações globais existentes que não sejam necessárias ao Entrelinhas.

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

4. O redirect `https://helicleiton.github.io/entrelinhas-gestao-cultural/` já foi adicionado à allowlist. O Site URL global continua `https://playbackflix.com.br` para não alterar o app que compartilha este projeto.
5. Para ativar Google: crie um OAuth Client do tipo Web no Google Cloud Console. Cadastre como Authorized redirect URI `https://egqwgyhpcdejxnwuweti.supabase.co/auth/v1/callback`. No provider Google do Supabase, insira Client ID e Client Secret diretamente no painel; nunca os coloque neste repositório ou no chat.
6. Depois de salvar o provider Google, publique as alterações locais. A chave anon/publishable do `supabase-config.js` é pública; a segurança dos dados é garantida pelas políticas RLS, nunca por esconder essa chave.

O cadastro por e-mail está habilitado no projeto. A confirmação de endereço permanece desativada conforme a configuração compartilhada atual. O login Google ainda requer o OAuth Client do Google Cloud.
