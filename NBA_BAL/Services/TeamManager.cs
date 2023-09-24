using DataAccess.DataModels;
using NBA_DAL.Repositories;

namespace NBA_BAL.Services
{
    public class TeamManager : ITeamManager
    {
        public readonly IRepository<TeamSummary> _repository;
        public TeamManager(IRepository<TeamSummary> repository)
        {
            _repository = repository;
        }

        public IEnumerable <TeamSummary> GetAllTeams()
        {
            try
            {
                return _repository.GetAll().ToList();
            } catch (Exception)
            {
                throw;
            }
        }

    }
}