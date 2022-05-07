page 70100 "CDS Employee List"
{
    PageType = List;
    SourceTable = "CDS new_employee";
    Editable = false;
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("No."; rec.new_No)
                {
                    ApplicationArea = all;
                }
                field("First Name"; rec.new_FirstName)
                {
                    ApplicationArea = all;
                }
                field("Last Name"; rec.new_LastName)
                {
                    ApplicationArea = all;
                }
                field("Name"; rec.new_Name)
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(CreateFromCDS)
            {
                ApplicationArea = All;
                Caption = 'Create in Business Central';
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Generate the table from the coupled Microsoft Dataverse worker.';

                trigger OnAction()
                var
                    CDSEmployee: Record "CDS new_employee";
                    CRMIntegrationManagement: Codeunit "CRM Integration Management";
                begin
                    CurrPage.SetSelectionFilter(CDSEmployee);
                    CRMIntegrationManagement.CreateNewRecordsFromCRM(CDSEmployee);
                end;
            }
        }
    }

    var
        CurrentlyCoupledCDSEmployee: Record "CDS new_employee";

    trigger OnInit()
    begin
        Codeunit.Run(Codeunit::"CRM Integration Management");
    end;

    procedure SetCurrentlyCoupledCDSEmployee(CDSEmployee: Record "CDS new_employee")
    begin
        CurrentlyCoupledCDSEmployee := CDSEmployee;
    end;
}