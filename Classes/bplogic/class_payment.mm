#include "class_payment.h"
#include "class_global_data.h"
#include "bpbase/bptools.h"
#include "bpbase/bpmacros.h"
#include "jsoncpp/json.h"

#include "bpprotocol/UrlDefine.h"

////////////////////////////////////////////////////////////////

#if CC_TARGET_PLATFORM == CC_PLATFORM_IOS
void class_payment::work(std::string order)
{
    if (m_the_callback)
        m_the_callback(m_the_payment, S_FALSE);
}
#endif
