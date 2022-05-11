tableextension 70101 "CDS Account" extends "CRM Account"
{
    Description = 'Een bedrijf dat een klant of een potentiële klant vertegenwoordigt. Het bedrijf dat wordt gefactureerd bij zakelijke transacties.';

    fields
    {

        field(10011; cr143_VATRegistrationNo; Text[100])
        {
            ExternalName = 'cr143_vatregistrationno';
            ExternalType = 'String';
            Description = '';
            Caption = 'VAT Registration No.';
        }
    }
}

//CRM Account List (5341, List)