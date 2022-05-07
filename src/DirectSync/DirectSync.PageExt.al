pageextension 70100 DirectSync extends "Customer List"
{
    actions
    {
        addafter(DeleteCRMCoupling)
        {
            action(DeleteDirect)
            {
                ApplicationArea = Suite;
                Caption = 'Delete Direct';
                Image = Delete;
                ToolTip = 'Delete the record directly in Business Central and Dataverse.';

                trigger OnAction()
                var
                    Customer: Record Customer;
                    CustomerDataverse: Record "O365 Customer";
                begin
                    CurrPage.SetSelectionFilter(Customer);
                    Customer.Delete;
                    if CustomerDataverse.Get(Customer."No.") then
                        CustomerDataverse.Delete;
                    CurrPage.Update();
                end;
            }
        }
    }
}