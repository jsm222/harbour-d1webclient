#include "webcontrol.h"

WebControl::WebControl(const QString &text, const QString &section, const QString &status, const QString &buttonId)
    : m_text(text), m_section(section),m_status(status),m_buttonId(buttonId)
{
}
WebControl::WebControl() {
    WebControl("","","","");
}

void WebControl::setStatus(QString status)
{
    m_status = status;
}
QString WebControl::text() const
{
    return m_text;
}

QString WebControl::section() const
{
    return m_section;
}
QString WebControl::status() const
{
    return m_status;
}
QString WebControl::buttonId() const
{
    return m_buttonId;
}
