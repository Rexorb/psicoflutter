# 🧠 PSICOFLUTTER: Gerenciamento de Pacientes e Relatórios

## 📝 Descrição do Projeto

O **PSICOFLUTTER** é um aplicativo mobile e desktop desenvolvido em Flutter, projetado para auxiliar psicólogos e terapeutas no gerenciamento eficiente de seus pacientes e no registro detalhado de relatórios de sessões.

O aplicativo utiliza um banco de dados local rápido para armazenar informações de pacientes e relatórios, além de integrar-se a uma API externa para agilizar o cadastro de endereços.

## 🚀 Funcionalidades Principais

| Módulo | Funcionalidade | Detalhe Técnico |
| :--- | :--- | :--- |
| **Pacientes** | Cadastro completo de pacientes | Nome, Data de Nascimento (com cálculo automático de idade), CEP, Endereço e Observações. |
| **ViaCEP** | Busca automática de endereço | Integração com a **API ViaCEP** para preenchimento automático do endereço ao informar o CEP. |
| **Relatórios** | Registro de sessões | Criação de relatórios vinculados a um paciente, com data da sessão, tipo (Presencial/Online), avaliação de humor (escala 1-10) e observações detalhadas. |
| **Gerenciamento** | CRUD completo | Permite **C**riar, **L**istar, **V**isualizar Detalhes e **E**xcluir (Delete) tanto pacientes quanto relatórios. |
| **Interface** | Navegação e Temas | Navegação simples via `BottomNavigationBar` e um tema visual com cores profissionais (Lapis Lazuli). |

## 🛠️ Tecnologias e Dependências

O projeto é construído em Flutter e utiliza as seguintes bibliotecas:

* **Flutter (Dart):** Framework principal para desenvolvimento cross-platform.
* **[Hive](https://pub.dev/packages/hive_flutter):** Utilizado como banco de dados NoSQL rápido e local para persistência de dados (Pacientes e Relatórios).
* **[http](https://pub.dev/packages/http):** Responsável pelas chamadas à API ViaCEP para busca de endereços.
* **[intl](https://pub.dev/packages/intl):** Utilizado para formatação de datas.

## 💾 Estrutura de Dados (Modelos Hive)

O aplicativo define dois modelos de dados principais, registrados como objetos Hive, garantindo persistência local e tipagem:

### 1. Paciente (`typeId: 2`)
| Campo | Tipo | Detalhe |
| :--- | :--- | :--- |
| `nome` | String | Nome completo do paciente. |
| `dataNascimento` | DateTime | Data de nascimento (para cálculo da idade). |
| `cep` | String | Código de Endereçamento Postal. |
| `endereco` | String | Endereço completo. |
| `observacoes` | String | Notas gerais sobre o paciente. |

### 2. Relatorio (`typeId: 1`)
| Campo | Tipo | Detalhe |
| :--- | :--- | :--- |
| `pacienteNome` | String | Nome do paciente vinculado ao relatório. |
| `data` | DateTime | Data da sessão. |
| `presencial` | bool | Indica se a sessão foi presencial (`true`) ou online (`false`). |
| `humor` | int | Avaliação de humor do paciente (escala de 1 a 10). |
| `observacoes` | String | Detalhes e notas da sessão. |

## ⚙️ Como Rodar o Projeto

### Pré-requisitos

1.  Instalação do **Flutter SDK** (versão estável).
2.  Instalação do **Android Studio** ou **VS Code** com as extensões Dart/Flutter.
3.  Um dispositivo ou emulador configurado (Android, iOS, Web ou Desktop Linux).

### Configuração

1.  **Clonar o Repositório:**
    ```bash
    git clone [https://docs.github.com/pt/migrations/importing-source-code/using-the-command-line-to-import-source-code/adding-locally-hosted-code-to-github](https://docs.github.com/pt/migrations/importing-source-code/using-the-command-line-to-import-source-code/adding-locally-hosted-code-to-github)
    cd psicoflutter
    ```

2.  **Instalar Dependências:**
    ```bash
    flutter pub get
    ```

3.  **Garantir o Setup do Android (se for compilar para Android):**
    Confirme que o caminho do seu SDK está correto no arquivo `android/local.properties`:
    ```properties
    sdk.dir=/home/rexorb/Android/sdk # (Verifique seu caminho)
    ```

4.  **Executar o Aplicativo:**
    ```bash
    flutter run
    ```
    Ou, para rodar no **Firefox (Web)**:
    ```bash
    flutter run -d web-server
    # Copie a URL gerada e cole no seu Firefox.
    ```

## 🎨 Paleta de Cores Personalizada

O projeto utiliza uma paleta customizada (classe `AppColors`) centrada na cor **Lápis-Lazúli** (`#26619C`) para criar uma identidade visual profissional e coesa.