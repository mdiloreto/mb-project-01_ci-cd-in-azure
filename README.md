# mb-project-01_ci-cd-in-azure
This repo is intented for developing a CI/CD in Azure using Terraform, GitHub Actions, Container Registry and App Service to deliver a Continous Integration and Continuos Delivery pipeline. 


# Cómo utilizar el Escenario de Laboratorio: 

    1. Crear el Remote State. 
    2. Configurar datos de Remote state en Backend.tf. 
    3. Login az:
        a. az login -t "<tenant-id>" --use-device-login
        b. az account list
        c. az account set -s "<subscription-id>" 
        d. az account show. 
    4. Realizar terraform Init. 
    5. Configurar variable de entorno: 
        a. $env:GIT_HUB = ""
    6. Terraform apply. 
    7. Configurar Secrets de Actions. 
        a. Utilizar el Output.
    8. Configurar Secret en App Registration "github_sp". 
    9. Configurar Secrets de Actions. 
        a. Utilizar el secret creado en el paso 8. 
    10. Crear archivo base .github/workflows/build.yaml
    11. Cargar archivos en Storage account. 
        a. Utilizar archivos de la forlder sa_images, dev.png y main.png.
    12. Automatic Testing:
        a. Utilizar test basico de Bash. 
            a. Utilizar .github/workflows/build_w_test.yaml
        b. Utilizar test de Image de Python. 
            a. Utilizar .github/workflows/build_w_all_test.yaml
    13. Utilizar cambios de Imagen a partir del mount. 

