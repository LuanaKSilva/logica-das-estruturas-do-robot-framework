*** Settings ***
Library    RequestsLibrary
Library    String
Library    Collections

*** Keywords ***
Criar um usuário novo
    ${any_words}    Generate Random String    length=4    chars=[LETTERS]
    ${any_words}    Convert To Lower Case    ${any_words}
    Set Test Variable    ${EMAIL_TEST}    ${any_words}@emailtest.com
    Log    ${EMAIL_TEST}

Cadastrar o usuário criado na ServeRest
    [Arguments]    ${email}    ${status_code_expected}
    ${body}    Create Dictionary    
    ...        nome=Fulano da Silva
    ...        email=${email}
    ...        password=1234    
    ...        administrador=true
    
    Log    ${body}

    Criar sessão na ServeRest

    ${response}    POST On Session    
    ...            alias=ServeRest
    ...            url=/usuarios
    ...            json=${body}
    ...            expected_status=${status_code_expected}
    
    Log    ${response.json()}

    IF    ${response.status_code} == 201
        Set Test Variable    ${ID_USERS}    ${response.json()["_id"]}
    END
    
    Set Test Variable    ${RESPONSE}    ${response.json()}

Criar sessão na ServeRest
    ${headers}    Create Dictionary    accept=application/json    Content-Type=application/json
    Create Session    alias=ServeRest    url=https://serverest.dev    	headers=${headers}

Conferir se o usuário foi cadastrado corretamente
    Log    ${RESPONSE}
    Dictionary Should Contain Item    dictionary=${RESPONSE}    key=message    value=Cadastro realizado com sucesso
    Dictionary Should Contain Key    dictionary=${RESPONSE}    key=_id

Vou repetir o cadastro do usuário
    Cadastrar o usuário criado na ServeRest    email=${EMAIL_TEST}    status_code_expected=400

Verificar se a API não permitiu o cadastro repetido
    Dictionary Should Contain Item    dictionary=${RESPONSE}    key=message    value=Este email já está sendo usado

Consultar os dados do novo usuário
    ${response_consult}    GET On Session    alias=ServeRest    url=/usuarios/${ID_USERS}
    Set Test Variable    ${RESP_CONSULT}    ${response_consult.json()}

Conferir os dados retornados
    Log    ${RESP_CONSULT}
    Dictionary Should Contain Item    dictionary=${RESP_CONSULT}    key=nome             value=Fulano da Silva
    Dictionary Should Contain Item    dictionary=${RESP_CONSULT}    key=email            value=${EMAIL_TEST}
    Dictionary Should Contain Item    dictionary=${RESP_CONSULT}    key=password         value=1234
    Dictionary Should Contain Item    dictionary=${RESP_CONSULT}    key=administrador    value=true
    Dictionary Should Contain Item    dictionary=${RESP_CONSULT}    key=_id              value=${ID_USERS}