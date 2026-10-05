
using { API_BUSINESS_PARTNER as external } from './external/API_BUSINESS_PARTNER';

service CatalogExtService {

    entity A_AddressEmailAddress as projection on external.A_AddressEmailAddress;

}
