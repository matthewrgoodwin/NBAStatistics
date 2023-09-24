using DataAccess.DataModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace NBA_BAL.Services
{
    public interface ITeamManager
    {
        public IEnumerable<TeamSummary> GetAllTeams();
    }
}
