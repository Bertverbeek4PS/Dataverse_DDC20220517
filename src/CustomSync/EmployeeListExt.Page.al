pageextension 70102 EmployeeListExt extends "Employee List"
{
    actions
    {
        addlast(processing)
        {
            action("Get Data From Dataverse")
            {
                ApplicationArea = All;
                Caption = 'Get Data From Dataverse';
                Image = Download;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    GetDataVerse;
                end;
            }
            action("Sync Data From Dataverse")
            {
                ApplicationArea = All;
                Caption = 'Sync Data From Dataverse';
                Image = Download;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    SyncDataVerse;
                end;
            }
        }
    }

    local procedure SyncDataVerse()
    var
        HumanResourceSetup: Record "Human Resources Setup";
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
        Employee: Record Employee;
        EmployeeVariant: Variant;
    begin
        Codeunit.Run(Codeunit::"CRM Integration Management");
        Employee.Reset;
        EmployeeVariant := Employee;
        CRMIntegrationManagement.UpdateMultipleNow(EmployeeVariant);
    end;

    local procedure GetDataVerse()
    var
        HumanResourceSetup: Record "Human Resources Setup";
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
        DataVerseEmployee: Record "CDS new_employee";
        CRMIntegrationRecord: record "CRM Integration Record";
        Employee: Record Employee;
    begin
        Codeunit.Run(Codeunit::"CRM Integration Management");
        CRMIntegrationRecord.Reset;
        CRMIntegrationRecord.SetRange("Table Id", rec.RecordId.TableNo);
        if CRMIntegrationRecord.FindSet then
            repeat
                Employee.Reset;
                Employee.SetRange(SystemId, CRMIntegrationRecord."Integration ID");
                If Employee.FindFirst() then begin
                    //Insert
                    DataVerseEmployee.Get(CRMIntegrationRecord."CRM ID");
                    CRMIntegrationManagement.CreateNewRecordsFromCRM(DataVerseEmployee);
                end;
            until CRMIntegrationRecord.Next = 0;
    end;
    //Comment
}