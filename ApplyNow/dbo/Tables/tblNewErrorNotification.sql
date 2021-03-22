CREATE TABLE [dbo].[tblNewErrorNotification] (
    [NewErrorID]  INT            IDENTITY (1, 1) NOT NULL,
    [DateAdded]   DATETIME       DEFAULT (getdate()) NOT NULL,
    [EmailBody]   NVARCHAR (MAX) NULL,
    [IsEmailSent] BIT            DEFAULT ((0)) NULL
);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [dbo].[tblNewErrorNotification].[EmailBody]
    WITH (LABEL = 'Confidential', LABEL_ID = '34a8b4cd-07bb-4681-a104-04b974736123', INFORMATION_TYPE = 'Contact Info', INFORMATION_TYPE_ID = '5c503e21-22c6-81fa-620b-f369b8ec38d1', RANK = MEDIUM);

