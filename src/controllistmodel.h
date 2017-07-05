#ifndef BUTTONLIST_H
#define BUTTONLIST_H
#include <QStringListModel>
#include <QString>
#include <QAbstractListModel>
#include "settings.h"
#include "webcontrol.h"
class ControlListModel : public QAbstractListModel {
    Q_OBJECT
public:
    enum WebButtonRoles {
        TextRole = Qt::UserRole + 1,
        SectionRole,
        StatusRole,
        ButtonIdRole
    };

    explicit ControlListModel(QObject *parent = 0);
    Q_INVOKABLE int nextIndex();
    Q_INVOKABLE bool removeRows(int row, int count, const QModelIndex &parent = QModelIndex());
    int rowCount(const QModelIndex&) const { return backing.size(); }
    Q_INVOKABLE QVariant data(const QModelIndex &index, int role) const;
    Q_INVOKABLE bool removeSection(QString sectionHeader);
    QHash<int, QByteArray> roleNames() const;
    Q_INVOKABLE void settingsChanged(int i,int i2);
    Q_INVOKABLE int listIndex(int buttonId);
private:
    QVector<WebControl> backing;
    Settings *m_settings;
public slots:
      void received(QString query, QString status, int index);

};
#endif // BUTTONLIST_H
