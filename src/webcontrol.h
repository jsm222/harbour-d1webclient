#ifndef WEBBUTTON_H
#define WEBBUTTON_H
#include <QString>


class WebControl
{
public:
    WebControl(const QString &text, const QString &section, const QString &status, const QString &buttonId);
    WebControl();
    QString text() const;
    QString section() const;
    QString status() const;
    QString buttonId() const;
    void setStatus(QString status);
private:
    QString m_text;
    QString m_section;
    QString m_status;
    QString m_buttonId;
};
#endif // WEBBUTTON_H
