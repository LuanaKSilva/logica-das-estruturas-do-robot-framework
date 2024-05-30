*** Settings ***
Library    SeleniumLibrary


*** Variables ***
${ADD_CARRINHO}                add-to-cart-button
${ADICIONADO_NO_CARRINHO}      //h1[contains(text(),'Adicionado ao carrinho')]
${BROWSER}                     chrome
${CARRINHO}                    nav-cart
${EXCLUIR}                     //input[contains(@value,'Excluir')]
${HEADER_ELETRONICOS}          //h1[contains(.,'Eletrônicos e Tecnologia')]
${MENU_ELETRONICOS}            //a[contains(text(),'Eletrônicos')]
${URL}                         https://www.amazon.com.br/
${REMOVIDO_DO_CARRINHO}        //h1[contains(text(),'Seu carrinho de compras da Amazon está vazio.')]


*** Keywords ***
Abrir o navegador
    Open Browser    browser=${BROWSER}
    Maximize Browser Window

Fechar o navegador
    Capture Page Screenshot
    Close Browser

Acessar a home page do site Amazon.com.br
    Go To    url=${URL}
    Sleep   10s
    Wait Until Element Is Visible    locator=${MENU_ELETRONICOS}

Entrar no menu "Eletrônicos"
    Click Element    locator=${MENU_ELETRONICOS}

Verificar se aparece a frase "${TEXT_HEADER}"
    Wait Until Page Contains    text=${TEXT_HEADER}
    Wait Until Element Is Visible    locator=${HEADER_ELETRONICOS}

Verificar se o título da página fica "${TITLE_SITE}"
    Title Should Be    title=${TITLE_SITE}

Verificar se aparece a categoria "${CATEGORY_NAME}"
    Element Should Be Visible    locator=//img[contains(@alt,'${CATEGORY_NAME}')]

Digitar o nome do produto "${PRODUCT}" no campo de pesquisa
    Input Text    locator=twotabsearchtextbox    text=${PRODUCT}

Clicar no botão de pesquisa
    Click Button    locator=nav-search-submit-button

Verificar se o resultado da pesquisa está listando o produto "${PRODUCT}" 
    Wait Until Element Is Visible    locator=(//span[contains(.,'${PRODUCT}')])[3]

Adicionar o produto "${PRODUTO}" no carrinho
    Click Element    locator=//span[@class='a-size-base-plus a-color-base a-text-normal'][contains(.,'${PRODUTO}')]
    Wait Until Element Is Visible    locator=${ADD_CARRINHO}
    Click Button    locator=${ADD_CARRINHO}

Verificar se o produto "${PRODUTO}" foi adicionado com sucesso
    Wait Until Element Is Visible    locator=${ADICIONADO_NO_CARRINHO}
    Click Link    locator=${CARRINHO}
    Wait Until Element Is Visible    locator=//span[@class='a-truncate-cut'][contains(.,'${PRODUTO}')]

Remover o produto "Console Xbox Series S" do carrinho
    Click Element   locator=${EXCLUIR}

Verificar se o carrinho fica vazio
    Wait Until Element Is Visible    locator=${REMOVIDO_DO_CARRINHO}

# GHERKIN STEPS
Dado que estou na home page da Amazon.com.br
    Acessar a home page do site Amazon.com.br

Quando acessar o menu "Eletrônicos"
    Entrar no menu "Eletrônicos"
    Verificar se aparece a frase "Eletrônicos e Tecnologia"

Então o título da página deve ficar "Eletrônicos e Tecnologia | Amazon.com.br"
    Verificar se o título da página fica "Eletrônicos e Tecnologia | Amazon.com.br"

E o texto "Eletrônicos e Tecnologia" deve ser exibido na página
    Verificar se aparece a categoria "Computadores e Informática"

E a categoria "Computadores e Informática" deve ser exibida na página
    Verificar se aparece a categoria "Tablets"

Quando pesquisar pelo produto "Xbox Series S"
    Digitar o nome do produto "Xbox Series S" no campo de pesquisa
    Clicar no botão de pesquisa

Então o título da página deve ficar "Amazon.com.br : Xbox Series S"
    Verificar se o título da página fica "Amazon.com.br : Xbox Series S"

E um produto da linha "Xbox Series S" deve ser mostrado na página
    Verificar se o resultado da pesquisa está listando o produto "Console Xbox Series S"

Quando adicionar o produto "Console Xbox Series S" no carrinho
    Digitar o nome do produto "Xbox Series S" no campo de pesquisa
    Clicar no botão de pesquisa
    Verificar se o resultado da pesquisa está listando o produto "Console Xbox Series S"
    Adicionar o produto "Console Xbox Series S" no carrinho

Então o produto "Console Xbox Series S" deve ser mostrado no carrinho
    Verificar se o produto "Console Xbox Series S" foi adicionado com sucesso

E existe o produto "Console Xbox Series S" no carrinho
    Quando adicionar o produto "Console Xbox Series S" no carrinho
    Verificar se o produto "Console Xbox Series S" foi adicionado com sucesso

Quando remover o produto "Console Xbox Series S" do carrinho
    Remover o produto "Console Xbox Series S" do carrinho

Então o carrinho deve ficar vazio
    Verificar se o carrinho fica vazio