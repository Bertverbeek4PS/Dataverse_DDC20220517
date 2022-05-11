pageextension 70103 "CRM Account List Ext." extends "CRM Account List"
{
    layout
    {
        addlast(Control2)
        {
            field(cr143_VATRegistrationNo; rec.cr143_VATRegistrationNo)
            {
                ApplicationArea = all;
            }
        }
    }
}