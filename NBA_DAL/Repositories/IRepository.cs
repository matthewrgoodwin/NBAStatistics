using DataAccess.DataModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace NBA_DAL.Repositories
{
    public interface IRepository <T>
    {
        public IEnumerable<T> GetAll();
    }
}
