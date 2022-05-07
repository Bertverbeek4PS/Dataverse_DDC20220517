pageextension 70101 "Employee Synch Extension" extends "Employee Card"
{
    actions
    {
        addlast(navigation)
        {
            group(ActionGroupCDS)
            {
                Caption = 'Dataverse';
                Visible = CDSIntegrationEnabled;

                action(CDSGotoWorker)
                {
                    Caption = 'Worker';
                    Image = CoupledCustomer;
                    ToolTip = 'Open the coupled Dataverse worker.';
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        CRMIntegrationManagement: Codeunit "CRM Integration Management";
                    begin
                        CRMIntegrationManagement.ShowCRMEntityFromRecordID(rec.RecordId);
                    end;
                }
                action(CDSSynchronizeNow)
                {
                    Caption = 'Synchronize';
                    ApplicationArea = All;
                    Visible = true;
                    Image = Refresh;
                    Enabled = CDSIsCoupledToRecord;
                    ToolTip = 'Send or get updated data to or from Microsoft Dataverse.';

                    trigger OnAction()
                    var
                        CRMIntegrationManagement: Codeunit "CRM Integration Management";
                    begin
                        CRMIntegrationManagement.UpdateOneNow(rec.RecordId);
                    end;
                }
                action(ShowLog)
                {
                    Caption = 'Synchronization Log';
                    ApplicationArea = All;
                    Visible = true;
                    Image = Log;
                    ToolTip = 'View integration synchronization jobs for the customer table.';

                    trigger OnAction()
                    var
                        CRMIntegrationManagement: Codeunit "CRM Integration Management";
                    begin
                        CRMIntegrationManagement.ShowLog(rec.RecordId);
                    end;
                }
                group(Coupling)
                {
                    Caption = 'Coupling';
                    Image = LinkAccount;
                    ToolTip = 'Create, change, or delete a coupling between the Business Central record and a Microsoft Dataverse row.';

                    action(ManageCDSCoupling)
                    {
                        Caption = 'Set Up Coupling';
                        ApplicationArea = All;
                        Visible = true;
                        Image = LinkAccount;
                        ToolTip = 'Create or modify the coupling to a Microsoft Dataverse Worker.';

                        trigger OnAction()
                        var
                            CRMIntegrationManagement: Codeunit "CRM Integration Management";
                        begin
                            CRMIntegrationManagement.DefineCoupling(rec.RecordId);
                        end;
                    }
                    action(DeleteCDSCoupling)
                    {
                        Caption = 'Delete Coupling';
                        ApplicationArea = All;
                        Visible = true;
                        Image = UnLinkAccount;
                        Enabled = CDSIsCoupledToRecord;
                        ToolTip = 'Delete the coupling to a Microsoft Dataverse Worker.';

                        trigger OnAction()
                        var
                            CRMCouplingManagement: Codeunit "CRM Coupling Management";
                        begin
                            CRMCouplingManagement.RemoveCoupling(rec.RecordId);
                        end;
                    }
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
        EmployeeVariant: Variant;
    begin
        CDSIntegrationEnabled := CRMIntegrationManagement.IsCDSIntegrationEnabled();
    end;

    // trigger OnClosePage()
    // var
    //     CRMIntegrationManagement: Codeunit "CRM Integration Management";
    //     datavers: Codeunit "Dataverse Events";
    // begin
    //     if NewRecord then
    //         CRMIntegrationManagement.CreateNewRecordsInCRM(rec.RecordID)
    //     else
    //         CRMIntegrationManagement.UpdateOneNow(rec.RecordId);
    // end;

    trigger OnAfterGetCurrRecord()
    begin
        if CDSIntegrationEnabled then
            CDSIsCoupledToRecord := CRMCouplingManagement.IsRecordCoupledToCRM(Rec.RecordId);

        NewRecord := false;
        if rec."No." = '' then
            NewRecord := true;
    end;

    var
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
        CRMCouplingManagement: Codeunit "CRM Coupling Management";
        CDSIntegrationEnabled: Boolean;
        CDSIsCoupledToRecord: Boolean;
        NewRecord: Boolean;

}