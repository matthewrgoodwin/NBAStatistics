using DataAccess.DataModels;
using Microsoft.Extensions.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace NBA_DAL.Repositories
{
    public class TeamRepository : BaseRepository, IRepository<TeamSummary>
    {
        public TeamRepository(IConfiguration configuration) : base(configuration)
        {
        }

        public IEnumerable<TeamSummary> GetAll() => List(
            "dbo.usp_TeamSummaries_GetAll",
            ReadTeamSummary
            );

        private TeamSummary ReadTeamSummary(IDataRecord dataRecord) => new TeamSummary()
        {
            TeamId = (int)dataRecord["TeamId"],
            Name = (string)dataRecord["Name"],
            LogoUrl = (string)dataRecord["Logo"],
            Stadium = (string)dataRecord["Stadium"],
            HomePageUrl = (string)dataRecord["URL"],
            HomeGamesPlayed = (int)dataRecord["HomeGamesPlayed"],
            AwayGamesPlayed = (int)dataRecord["AwayGamesPlayed"],
            TotalGamesPlayed = (int)dataRecord["TotalGamesPlayed"],
            TotalGamesLost = (int)dataRecord["TotalGamesLost"],
            TotalGamesWon = (int)dataRecord["TotalGamesWon"],
            MVP = (string)dataRecord["SeasonMVP"],
            BiggestWinPointsFor = (int)dataRecord["BiggestWinPointsFor"],
            BiggestWinPointsAgainst = (int)dataRecord["BiggestWinPointsAgainst"],
            BiggestLossPointsFor = (int)dataRecord["BiggestLossPointsFor"],
            BiggestLossPointsAgainst = (int)dataRecord["BiggestLossPointsAgainst"],
            LastGameDate = (DateTime)dataRecord["LastGameDate"],
            LastGameStadium = (string)dataRecord["LastGameStadium"]
        };
    }
}