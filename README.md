# Table of contents
## 1	Another AI experience in Business Central
## 2	Functional flow resume
## 3	Feature in action
## 4	Functional flow in detail
### 4.1	Step 1. Email	
### 4.2	Logic Apps
### 4.3	Azure Stockage Account
### 4.4	Business Central file recovery from Blob Storage
### 4.5	Azure Document Intelligence Instance
### 4.6	Business Central interacts with an AI model to understand the document type and perform matching
## 5 Conclusion
 
## 1	  Another AI experience in Business Central
At BMS, we were working on a project to integrate documents into Business Central using AI. There wasn't enough time to move this POC forward, so Microsoft beat us to it.. The public preview of version 26 of Business Central features the Payable Agent, capable of integrating a purchase invoice from a PDF file.
Our project was set up in the same way as Microsoft's (Same components), except that it supported other documents, not just purchase invoices.
This is a POC, a basis for continuing a major project.

## 2	  Functional flow resume
 ![image](https://github.com/user-attachments/assets/3823d348-77ff-4629-8ab3-a256a10a5dc5)

## 3	 Feature in action

[![Watch the video](https://img.youtube.com/vi/YXK1lGu7PWU/0.jpg)](https://www.youtube.com/watch?v=_YXK1lGu7PWU)

https://youtu.be/YXK1lGu7PWU

## 4	Functional flow in detail
### 4.1	 Step 1. Email
There is no specific requirement for the email address except that Logic Apps will need to have access to it in the next step. In my case, in my case I am using a shared mail mailbox.
![image](https://github.com/user-attachments/assets/1393d519-8b8e-4727-a01d-6bf285113dc2)
 
### 4.2	Logic Apps


### 4.3	Azure Stockage Account
You need to create a storage account to deposit files received by email. This account must be accessible by 3 components of our functionality:
- LogicApp and Document Intelligence instances
To do this, we need to use the RBAC (role-based access control) approach to give the “Storage Blob Data Contributor” role to an managed entity, our LogicApp instance:
 ![image](https://github.com/user-attachments/assets/1794ec57-56fc-411e-9e39-566b1ee6ea83)


Result:
![image](https://github.com/user-attachments/assets/6874ee87-3d35-4fd0-a816-10ec02cc4e99)

an alternative solution for this access could be to use Azure resource sharing or CORS (Cross-Origin resource Planning).
![image](https://github.com/user-attachments/assets/88b4a4bb-f437-49c1-9e51-4e8368b81524)

 
-Business Central through API calls
in order to access our storage account from Business Central, we need to enable access from all networks or the specific network from which you wish to connect.
![image](https://github.com/user-attachments/assets/64175836-5a35-471b-922f-f5f7a33cd17d)

Then you need to retrieve the access keys to the storage account required for the call from Business Central.
![image](https://github.com/user-attachments/assets/fa55a059-dd11-458f-ab50-85dabad35e0c)

 
### 4.4	Business Central file recovery from Blob Storage
To do this, we rely on Business Central's BCApps libraries: https://github.com/microsoft/BCApps/tree/main/src
![image](https://github.com/user-attachments/assets/431cdab7-3be0-47fa-b965-6802309a084c)
 
The key to this call is the construction of the call URL as follows. 
https://<storage account name>.blob.core.windows.net>/<Container name>
Here's the source code using ABS objects (note that this is a POC, the keys are cached via value isolation or Azure Key vault).
![image](https://github.com/user-attachments/assets/8f3b08da-1c58-4faa-99d2-f0f5ef40104f)

Result:
![image](https://github.com/user-attachments/assets/8fbd3d27-4a24-4fdd-8ac3-b3c3658d2989)

### 4.5	Azure Document Intelligence Instance
AI Document Intelligence is an AI service that applies advanced machine learning to extract text, key-value pairs, tables, and structures from documents automatically and accurately. Turn documents into usable data and shift your focus to acting on information rather than compiling it. 
A Document Intelligence instance must be created to process our documents. The process is easy and straightforward, several analysis models are available. For our POC we have chosen General documents in order to integrate a large number of documents.
![image](https://github.com/user-attachments/assets/b1995080-3da3-435d-8e76-df97f9b1527e)

Several recognition models are available, in our POC we use the “General Documents” model to process many document types.
![image](https://github.com/user-attachments/assets/3b10910f-615e-453e-afdb-360b92902a75)
 
A user interface for model testing in Document intelligence Studio
![image](https://github.com/user-attachments/assets/4d57785b-fc14-4074-92da-374f6acbb5d9)
 
As we saw above, Document Intelligence must have access to the Container.
To build the URL to submit the document from the blob, proceed as follows:
- Generate an access token for the Container used, define call type (Https or http) and token duration:
![image](https://github.com/user-attachments/assets/4ff0fd6d-48bc-4c9a-9369-e9ad7be4a0e2)

- Recover the url of the Blob to submit to add the token to the address  url structure: https://<blob url>?<Container token>
![image](https://github.com/user-attachments/assets/6cf78c1c-9032-4073-81ff-a7c14f1300d4)

Calling from Business Central is a two-step process. 
- Submission of the file (POST)
- Retrieval of the result (GET). 
Below is the function code:
![image](https://github.com/user-attachments/assets/a2353880-7302-427d-8afd-697f5fb71260)


### 4.6	Business Central interacts with an AI model to understand the document type and perform matching
The principle here is to use an AI model to determine what type of document it is from a list sub-mitted in the prompt, sales order, Purchase order, etc.
This requires an Azure Foundry instance with a deployed AI model. (To check in detail, authorization, registration and validation, how deploy a model, see our article on function calling).
![image](https://github.com/user-attachments/assets/b1f753f6-5853-48fa-b90a-fb64fd11e71e)
 
once this model is in place, all we have to do is call it:
- Submitting the contents of our file and the list of possible document types, code below:
 ![image](https://github.com/user-attachments/assets/31ed0850-1515-4f01-97c5-a4994d73fdd0)

- Depending on the type of document returned, submit the fields of the page concerned and the content of the file, the AI will return the matching made. Code Below:
![image](https://github.com/user-attachments/assets/6369a1eb-b451-46db-9378-f30ad22fd6ff)

Launch function from Business Central
![image](https://github.com/user-attachments/assets/ab3b7b1d-7d53-4cda-8b7b-541ad89f6bf3)

Output from Business Central
![image](https://github.com/user-attachments/assets/84853542-0bcc-426a-976a-251aa4c8e85f)

## 5	Conclusion
It's not difficult to imagine an infinite number of uses from this POC.
For our part, we are continuing our experimentation to offer a simple and flexible solution for integrating binary files of various types into Business Central.
Don't hesitate to contact us if you'd like additional information or even to participate in this project.
The source code is on my GitHub repository: https://github.com/BMSPedro/OCR.git








