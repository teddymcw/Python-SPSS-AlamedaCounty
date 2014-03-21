Sort cases by ethnic.
Match Files /Table='//covenas/decisionsupport/ethnicity.sav' /File=* /by ethnic.
If hispanic="G" or hispanic="M" or hispanic="N" or hispanic="S" or hispanic="5" or hispanic="2" Ethnicity="Latino".
If hispanic="G" or hispanic="M" or hispanic="N" or hispanic="S" or hispanic="5" or hispanic="2" RaceEthnicityCode="2".
If Ethnicity=" " or Ethnicity="Other" or Ethnicity="Unknown" Ethnicity="Other/Unknown".
match files /file=* /drop EthnicDetail PacificIslander ethnic.
