#include "controllistmodel.h"


ControlListModel::ControlListModel(QObject *parent) : QAbstractListModel(parent)
{
    m_settings = new Settings();


    QStringList groups = m_settings->getSettings()->childGroups();

    foreach (const QString group, groups) {
        if(!group.startsWith("General")) {
            WebControl b = WebControl(
                        m_settings->value(group+"/buttonText").toString(),
                        m_settings->value(group+"/sectionHeader").toString(),
                        "",
                        group.mid(9));
            backing.append(b);
        }
    }
    std::sort( backing.begin( ), backing.end( ), [ ]( const WebControl& a, const WebControl& b )
    {
          return a.section() < b.section();
    });

}
void ControlListModel::received(QString query,QString status,int index) {
    if(index>-1) {
        backing[index].setStatus(query + " " + status);
        QModelIndex top = this->createIndex(index, 0);
        QModelIndex bottom = this->createIndex(index, 0);
        emit dataChanged(top,bottom);
    }
}



void ControlListModel::settingsChanged(int i,int i2)
{
    QString group = QString("webclient%1").arg(i);
    if(i2==-1) {
        beginInsertRows(QModelIndex(), backing.count(), backing.count());
        backing.append(WebControl(
                           m_settings->value(group+"/buttonText").toString(),
                           m_settings->value(group+"/sectionHeader").toString(),
                           "",
                           group.mid(9)));
        std::sort( backing.begin( ), backing.end( ), [ ]( const WebControl& a, const WebControl& b )
        {
            return a.section() < b.section();
        });
        endInsertRows();
    } else {
        backing.replace(i2,WebControl(
                            m_settings->value(group+"/buttonText").toString(),
                            m_settings->value(group+"/sectionHeader").toString(),
                            "",
                            group.mid(9)));

        std::sort( backing.begin( ), backing.end( ), [ ]( const WebControl& a, const WebControl& b )
        {
            return  a.section() < b.section();
        });
    }

    QModelIndex top = this->createIndex(0, 0);
    QModelIndex bottom = this->createIndex(backing.size(), 0);
    emit dataChanged(top,bottom);


}

QHash<int, QByteArray> ControlListModel::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[TextRole] = "buttonText";
    roles[SectionRole] = "section";
    roles[StatusRole] = "status";
    roles[ButtonIdRole] = "buttonId";
    return roles;
}

QVariant ControlListModel::data(const QModelIndex &index, int role) const {
    if(!index.isValid()) {
        return QVariant();
    }
    if(role == TextRole) {
        return QVariant(backing[index.row()].text());
    }
    if(role == SectionRole) {
        return QVariant(backing[index.row()].section());
    }
    if(role == StatusRole) {
        return QVariant(backing[index.row()].status());
    }
    if(role == ButtonIdRole) {
        return QVariant(backing[index.row()].buttonId());
    }
    return QVariant();
}

bool ControlListModel::removeRows(int row,int count, const QModelIndex &parent)
{
     if(row>=0 && row<backing.count() && count==1)
     {
         beginRemoveRows(parent,row,row);
         if(m_settings->value("CoverOn").toInt() == backing[row].buttonId().toInt()) {
             m_settings->getSettings()->remove("CoverOn");
         }
         if(m_settings->value("CoverOff").toInt() == backing[row].buttonId().toInt()) {
             m_settings->getSettings()->remove("CoverOff");
         }
         backing.removeAt(row);
         endRemoveRows();
         return true;
    }
     return false;
}


int ControlListModel::nextIndex()
{
    int ret = -1;
    QVector<int> b;
    foreach(WebControl c,backing) {
        b.append(c.buttonId().toInt());
    }
    if(b.size() == 0) {
        return 0;
    }
    std::sort( b.begin(), b.end() );
    if (*b.begin() > 0) {
        ret = *b.begin() -1;
    } else {
    auto i = std::adjacent_find( b.begin(), b.end(), [](int l, int r){return l+1<r;} );

    if ( i == b.end() )
        --i;
    ret = 1+*i;
    }
    return ret;
}
int ControlListModel::listIndex(int buttonId)
{

    for(int i =0;i<backing.size();i++) {
           if(backing[i].buttonId().toInt()==buttonId) {
               return i;
           }
        }
        return -1;
}
bool ControlListModel::removeSection(QString sectionHeader) {
    int minRow =-1;
    int maxRow = -1;
    for (int i=0;i<backing.size();i++) {
        if(backing[i].section() == sectionHeader) {
            m_settings->remove(backing[i].buttonId().toInt());
            if(m_settings->value("CoverOn").toInt() == backing[i].buttonId().toInt()) {
                m_settings->getSettings()->remove("CoverOn");
            }
            if(m_settings->value("CoverOff").toInt() == backing[i].buttonId().toInt()) {
                m_settings->getSettings()->remove("CoverOff");
            }
            if(minRow == -1) {
                minRow = i;
            }
            if (maxRow<i) {
                maxRow =i;
            }
        }
    }
    beginRemoveRows(QModelIndex(),minRow,maxRow);
    backing.erase(backing.begin() + minRow,backing.begin() + maxRow+1);
    endRemoveRows();
    return true;
}
