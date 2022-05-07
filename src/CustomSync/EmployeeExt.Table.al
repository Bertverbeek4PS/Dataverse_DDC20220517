tableextension 70100 EmployeeExt extends Employee
{
    fields
    {
        field(50200; "Coupled to Dataverse"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    trigger OnAfterInsert()
    var
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
    begin
        //CRMIntegrationManagement.CreateNewRecordsInCRM(rec.RecordID);
    end;

    trigger OnAfterModify()
    var
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
    begin
        //CRMIntegrationManagement.UpdateOneNow(rec.RecordId);
    end;
}